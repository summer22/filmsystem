// ==UserScript==
// @name        AVPO
// @description audio/video player online
// @include     *
// @version     0.2
// @updateURL   https://www.hskj100.com/avpo.user.js
// @run-at      document-start
// @inject-into content
// @grant       GM.xmlHttpRequest
// ==/UserScript==

function rangeParser(size, str, options) {
  if (typeof str !== 'string') {
    throw new TypeError('argument str must be a string')
  }

  var index = str.indexOf('=')

  if (index === -1) {
    return -2
  }

  // split the range string
  var arr = str.slice(index + 1).split(',')
  var ranges = []

  // add ranges type
  ranges.type = str.slice(0, index)

  // parse all ranges
  for (var i = 0; i < arr.length; i++) {
    var range = arr[i].split('-')
    var start = parseInt(range[0], 10)
    var end = parseInt(range[1], 10)

    // -nnn
    if (isNaN(start)) {
      start = size - end
      end = size - 1
      // nnn-
    } else if (isNaN(end)) {
      end = size - 1
    }

    // limit last-byte-pos to current length
    if (end > size - 1) {
      end = size - 1
    }

    // invalid or unsatisifiable
    if (isNaN(start) || isNaN(end) || start > end || start < 0) {
      continue
    }

    // add range
    ranges.push({
      start: start,
      end: end
    })
  }

  if (ranges.length < 1) {
    // unsatisifiable
    return -1
  }

  return options && options.combine
    ? combineRanges(ranges)
    : ranges
}

function combineRanges(ranges) {
  var ordered = ranges.map(mapWithIndex).sort(sortByRangeStart)

  for (var j = 0, i = 1; i < ordered.length; i++) {
    var range = ordered[i]
    var current = ordered[j]

    if (range.start > current.end + 1) {
      // next range
      ordered[++j] = range
    } else if (range.end > current.end) {
      // extend range
      current.end = range.end
      current.index = Math.min(current.index, range.index)
    }
  }

  // trim ordered array
  ordered.length = j + 1

  // generate combined range
  var combined = ordered.sort(sortByRangeIndex).map(mapWithoutIndex)

  // copy ranges type
  combined.type = ranges.type

  return combined
}

function mapWithIndex(range, index) {
  return {
    start: range.start,
    end: range.end,
    index: index
  }
}

function mapWithoutIndex(range) {
  return {
    start: range.start,
    end: range.end
  }
}

function sortByRangeIndex(a, b) {
  return a.index - b.index
}

function sortByRangeStart(a, b) {
  return a.start - b.start
}

const cloudFilesCache = {};

async function AVPOFetchFiles(fids) {
  return new Promise((resolve, reject) => {
    var files = {};
    var reqfids = [];
    for (const fileId of fids) {
      const cacheFile = cloudFilesCache[fileId];
      if (cacheFile && cacheFile.Expires > (Date.now() / 1000)) {
        files[fileId] = cacheFile;
      } else {
        reqfids.push(fileId);
      }
    }
    if (reqfids.length == 0) {
      resolve(files);
      return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open('GET', `https://avpo.com/file/${reqfids}`, true);
    xhr.responseType = 'json';
    // 处理请求完成时的回调
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            // 请求成功时，状态码为 200
            var response = xhr.response;
            if (xhr.status === 200) {
                alert(xhr.responseText)
            } else {
                // 请求失败时的处理
                console.error('Request failed with status:', xhr.status);
            }
            if (response.status != 200) {
                 reject({ status: response.status, statusText: response.statusText });
                 return;
            }
            const object = response.response;
            if (object.code != 0) {
                       reject({ status: object.code, statusText: object.message });
                       return;
                     }
            const resfiles = object.data;
            for (const file of resfiles) {
                       if (file.Error != null) {
                         reject({ status: 500, statusText: file.Error });
                         return;
                       }
                       for (const container of Object.values(file.Download.Containers)) {
                         container.ContainerLength = container.Chunks.reduce((total, chunk) => total + chunk.ChunkLength, 0);
                       }
                       cloudFilesCache[file.Id] = file;
                       files[file.Id] = file;
                     }
            resolve(files);
        }
    };

    // 发送请求
    xhr.send();

//     GM.xmlHttpRequest({
//       method: 'GET',
//       // 这里必须使用绝对地址, 因为 UserScripts 不能使用相对地址
//       url: `https://avpo.com/file/${reqfids}`,
//       responseType: 'json',
//       onload: (response) => {
//         if (response.status != 200) {
//           reject({ status: response.status, statusText: response.statusText });
//           return;
//         }
//         const object = response.response;
//         if (object.code != 0) {
//           reject({ status: object.code, statusText: object.message });
//           return;
//         }
//         const resfiles = object.data;
//         for (const file of resfiles) {
//           if (file.Error != null) {
//             reject({ status: 500, statusText: file.Error });
//             return;
//           }
//           for (const container of Object.values(file.Download.Containers)) {
//             container.ContainerLength = container.Chunks.reduce((total, chunk) => total + chunk.ChunkLength, 0);
//           }
//           cloudFilesCache[file.Id] = file;
//           files[file.Id] = file;
//         }
//         resolve(files);
//       }
//     });


  });
}

class AVPOFetch {
  constructor(fileIds, chunksize, range, port) {
    this.FileIds = fileIds;
    this.ChunkSize = chunksize * 1024 * 1024;
    this.Range = range;
    this.Port = port;

    this.Canceld = false;

    this.Files = [];
    this.Length = 0;

    this.Begin = 0;
    this.End = 0;

    port.onmessage = this.onmessage.bind(this);
  }

  onmessage(event) {
    const message = event.data;
    switch (message.action) {
      case 'cancel':
        this.Canceld = true;
        break;
    }
  }

  async Open() {
    try {
      const files = await AVPOFetchFiles(this.FileIds);
      for (const fileId of this.FileIds) {
        const file = files[fileId];
        file.Offset = this.Length;
        this.Files.push(file);
        this.Length += file.Length;
      }
      this.End = this.Length - 1;
      if (this.Range != null) {
        const ranges = rangeParser(this.Length, this.Range);
        this.Begin = ranges[0].start;
        this.End = ranges[0].end;
      }
      const headers = {};
      headers["Accept-Ranges"] = "bytes";
      headers["Content-Length"] = this.Length;
      headers["Content-Range"] = `bytes ${this.Begin}-${this.End}/${this.Length}`;
      headers["Content-Type"] = this.Files[0].Extra.Metadata.type ?? "video/mp4";
      this.Port.postMessage({ action: "response", status: 206, statusText: "Partial Content", headers: headers });
      await this.Read();
    } catch (error) {
      this.Port.postMessage({ action: "response", status: 500, statusText: error.statusText });
    }
  }

  async Read() {
    try {
      var offset = this.Begin;
      var length = this.End - this.Begin + 1;
      while (!this.Canceld && length > 0) {
        for (const file of this.Files) {
          if (file.Offset <= offset && file.Offset + file.Length > offset) {
            const offsetForFile = offset - file.Offset;
            const lengthForFile = Math.min(length, file.Length - offsetForFile);
            const data = await this.ReadChunk(file, offsetForFile, Math.min(lengthForFile, this.ChunkSize));
            offset += data.byteLength;
            length -= data.byteLength;
            this.Port.postMessage({ action: "stream", data: data, eof: length <= 0 }, [data.buffer]);
            break;
          }
        }
      }
    } catch (error) {
      this.Port.postMessage({ action: "stream", eof: true });
    }
  }

  async ReadChunk(file, offset, size) {
    return new Promise((resolve, reject) => {
      let offset_is_correct = false;
      var fileOffset = 0;
      for (const reference of file.Download.References) {
        const container = file.Download.Containers[reference.ContainerIndex];
        const chunk = container.Chunks[reference.ChunkIndex];
        if (offset >= fileOffset && offset < fileOffset + chunk.ChunkLength) {
          const chunkOffset = offset - fileOffset;
          const containerOffset = chunk.ContainerOffset + chunkOffset;
          const containerLength = Math.min(chunk.ChunkLength - chunkOffset, size);
          const headers = Object.entries(container.Headers).filter(([key]) => key !== 'Host' && key !== 'Range').reduce((acc, [key, value]) => {
            acc[key] = value;
            return acc;
          }, {});
          headers["Range"] = `bytes=${containerOffset}-${containerOffset + containerLength - 1}`;

          var xhr = new XMLHttpRequest();
          xhr.open('GET', container.URI, true);
           xhr.headers = headers，
          xhr.responseType = 'arraybuffer';
          // 处理请求完成时的回调
          xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            // 请求成功时，状态码为 200
            var response = xhr.response;
            if (xhr.status === 200) {
                alert(xhr.responseText)
            } else {
                // 请求失败时的处理
                console.error('Request failed with status:', xhr.status);
            }

             if (response.status != 206) {
                  reject(response.statusText);
                  return;
              }
              const data = new Uint8Array(response.response);
              resolve(data);
        }
    };
          // 发送请求
          xhr.send();

//           GM.xmlHttpRequest({
//             method: 'GET',
//             url: container.URI,
//             headers: headers,
//             responseType: 'arraybuffer',
//             onload: (response) => {
//               if (response.status != 206) {
//                 reject(response.statusText);
//                 return;
//               }
//               const data = new Uint8Array(response.response);
//               resolve(data);
//             }
//           });

          offset_is_correct = true;
          break;
        }
        fileOffset += chunk.ChunkLength;
      }
      if (!offset_is_correct) {
        reject("offset is incorrect");
      }
    });
  }
}

// 注册 Service Worker
async function serviceWorkerRegister() {
  if ('serviceWorker' in navigator) {
      alert("serviceWorkerRegister-success");
    try {
      const registration = await navigator.serviceWorker.register('avpo.service.js');
      if (!registration) {
        throw new Error('Service Worker registration failed');
      }
      navigator.serviceWorker.addEventListener('controllerchange', () => {
        window.location.reload();
      });
      navigator.serviceWorker.addEventListener("message", (event) => {
       alert("serviceWorkerRegister-message");
        if (event.data.action === 'request') {
          const { fileIds, chunkSize, range } = event.data;
          const ifetch = new AVPOFetch(fileIds, chunkSize, range, event.ports[0]);
          ifetch.Open();
        } else if (event.data.action === 'alive') {
          const webport = event.ports[0];
          webport.postMessage({ action: "alive", from: 'UserScript' });
          webport.close();
        }
      });
      registration.active.postMessage({ action: "register", from: 'UserScript' });
    } catch (error) {
        alert(error);
      console.error(`register clouder service failed with ${error}`);
    }
  }else{
      alert("serviceWorkerRegister-fail");
  }
}

serviceWorkerRegister();