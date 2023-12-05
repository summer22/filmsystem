import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/dao/download/download_dao.dart';
import 'package:filmsystem/data/dao/download/download_info_model.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<DownloadInfoModel>?>? modelList;

  @override
  void initState() {
    super.initState();
    modelList = getData();
  }

  Future<List<DownloadInfoModel>> getData() async {
    try {
      return await DownloadDao.searchDatas();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              onTap: () => Get.back()),
        ),
        title: Text(
          'my_download'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _vListView(),
    );
  }

  Widget _vListView() {
    return FutureBuilder<List<DownloadInfoModel>?>(
      future: modelList,
      builder: (BuildContext context,
          AsyncSnapshot<List<DownloadInfoModel>?> snapshot) {
        if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return _item(snapshot.data?[index]);
            },
          );
        } else {
          return Center(
            child: Text(
              'empty'.tr,
              style: const TextStyle(color: Colors.white60),
            ),
          );
        }
      },
    );
  }

  Widget _item(DownloadInfoModel? model) {
    return Slidable(
      key:  ValueKey(model?.id ?? 0),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (_) {
              // 删除项时的回调
              DownloadDao.delete(model?.id ?? 0).then(
                      (value) => {
                    DownloadDao.deleteLocalFile(model?.filePath ?? "")
                  }
              );
              // 弹出一个提示
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('delete_success'.tr, textAlign: TextAlign.center,),
                ),
              );
              setState(() {
                modelList = getData();
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete'.tr,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const VideoPage(),
              arguments: {
                "headNo":
                model?.headNo
              });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: CachedNetworkImage(
                  key: ValueKey(model?.dramaUrl ?? ''),
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) {
                    return Image.asset(
                      defaultAssets,
                      fit: BoxFit.cover,
                    );
                  },
                  imageUrl: model?.dramaUrl ?? '',
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      defaultAssets,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(model?.intro ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(model?.updateDate ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );

    // return Dismissible(
    //   key: Key((model?.id ?? 0).toString()),
    //   onDismissed: (direction) {
    //     // 删除项时的回调
    //     // DownloadDao.delete(model?.id ?? 0).then(
    //     //         (value) => {
    //     //       DownloadDao.deleteLocalFile(model?.filePath ?? "")
    //     //     }
    //     // );
    //     // 弹出一个提示
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('删除成功', textAlign: TextAlign.center,),
    //       ),
    //     );
    //     // setState(() {
    //     //   modelList = getData();
    //     // });
    //   },
    //   background: Container(
    //     color: Colors.red,
    //     alignment: Alignment.centerRight,
    //     padding: const EdgeInsets.only(right: 16.0),
    //     child: const Icon(
    //       Icons.delete,
    //       color: Colors.white,
    //     ),
    //   ),
    //   child: GestureDetector(
    //     onTap: () {
    //       Get.to(() => const VideoPage(),
    //           arguments: {
    //             "headNo":
    //             model?.headNo
    //           });
    //     },
    //     child: Container(
    //       margin: const EdgeInsets.only(bottom: 10),
    //       padding: const EdgeInsets.all(15),
    //       height: 130,
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           AspectRatio(
    //             aspectRatio: 3 / 2,
    //             child: CachedNetworkImage(
    //               key: ValueKey(model?.dramaUrl ?? ''),
    //               fit: BoxFit.fitWidth,
    //               placeholder: (context, url) {
    //                 return Image.asset(
    //                   defaultAssets,
    //                   fit: BoxFit.cover,
    //                 );
    //               },
    //               imageUrl: model?.dramaUrl ?? '',
    //               errorWidget: (context, url, error) {
    //                 return Image.asset(
    //                   defaultAssets,
    //                   fit: BoxFit.cover,
    //                 );
    //               },
    //             ),
    //           ),
    //           Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Padding(
    //                     padding:
    //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //                     child: Text(model?.intro ?? "",
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 2,
    //                         style: const TextStyle(color: Colors.white)),
    //                   ),
    //                   Padding(
    //                     padding:
    //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //                     child: Text(model?.updateDate ?? "",
    //                         overflow: TextOverflow.ellipsis,
    //                         style: const TextStyle(color: Colors.white)),
    //                   ),
    //                 ],
    //               )),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
