import 'package:dio/dio.dart';
import 'package:filmsystem/data/dao/download/download_dao.dart';
import 'package:filmsystem/data/dao/download/download_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownloader {

  final Dio _dio = Dio();

  Future<void> downloadVideo(DownloadInfoModel info) async {
    final searchObj = await DownloadDao.search(info.id!);
    if (searchObj != null) {
      // Resume downloaseard
      if(searchObj.statue == 1) {
        debugPrint('本地已存在下载完成的资源');
        return;
      }
      await _resumeDownload(searchObj);
    } else {
      // Start a new download
      await _startNewDownload(info);
    }
  }

  Future<void> _resumeDownload(DownloadInfoModel download) async {
    final String filePath = await _getLocalFilePath(download.filmUrl ?? "");
    try {
      await _dio.download(
        download.filmUrl ?? "",
        filePath,
        options: Options(
          headers: {'range': 'bytes=${download.receivedBytes}-'},
        ),
        onReceiveProgress: (receivedBytes, totalBytes) async {
          download.receivedBytes = receivedBytes;
          download.statue = receivedBytes == totalBytes ? 1 : 2;
          await DownloadDao.update(download);
        },
      );
    } catch (e) {
      debugPrint('Error resuming download: $e');
    }
  }

  Future<void> _startNewDownload(DownloadInfoModel download) async {
    try {
      Response response = await _dio.head(download.filmUrl ?? "");

      final String filePath = await _getLocalFilePath(download.filmUrl ?? "");
      final String? contentLengthHeader = response.headers.value('content-length');
      final int totalBytes = int.tryParse(contentLengthHeader ?? "") ?? 0;

      download.filePath = filePath;
      download.totalBytes = totalBytes;
      download.receivedBytes = 0;
      download.statue = 2;

      await DownloadDao.insert(download);

      await _dio.download(
        download.filmUrl ?? "",
        filePath,
        options: Options(
          headers: {'range': 'bytes=0-'},
        ),
        onReceiveProgress: (receivedBytes, totalBytes) async {
          download.receivedBytes = receivedBytes;
          download.statue = receivedBytes == totalBytes ? 1 : 2;
          await DownloadDao.update(download);
          debugPrint('download bytes: $receivedBytes / $totalBytes');
        },
      );
    } catch (e) {
      debugPrint('Error starting new download: $e');
    }
  }

  Future<String> _getLocalFilePath(String url) async {
    Uri videoUri = Uri.parse(url);
    String videoFileName = videoUri.pathSegments.last;

    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$videoFileName';
  }

}