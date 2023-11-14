import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/base_model.dart';
import 'package:filmsystem/data/models/detail/detail_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/buttons/button.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final String title = Get.arguments["title"];
  final String headNo = Get.arguments["headNo"];

  Future<DetailModel?>? detailModel;
  DetailModel? recordDetailModel;

  Future<DetailModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.detail;
    request.add("headNo", headNo);
    try {
      ApiResponse response = await Api().fire(request);
      recordDetailModel = DetailModel.fromJson(response.data);
      return Future.value(recordDetailModel);
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }


  void _getCollectData({bool isCollect = true}) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.isShowLoading = false;
    request.path = isCollect ? ApiPath.insert : ApiPath.delete;
    request.add("headNo", headNo);
    try {
      ApiResponse response = await Api().fire(request);
      // BaseModel collectModel = BaseModel.fromJson(response.data);
      recordDetailModel?.data?.isCollect = isCollect;
      detailModel = Future.value(recordDetailModel);
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void _getLikesData({bool isLike = true}) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.isShowLoading = false;
    request.path = ApiPath.likes;
    request.add("headNo", headNo);
    request.add("isLike", isLike ? 1 : 0);
    try {
      ApiResponse response = await Api().fire(request);
      // BaseModel likeModel = BaseModel.fromJson(response.data);
      recordDetailModel?.data?.isLike = isLike ? 1 : 0;
      detailModel = Future.value(recordDetailModel);
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() async {
    detailModel = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) =>
              GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                  onTap: () => Get.back()),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CustomScrollView(
          slivers: [
            _header(),
            _gridView(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return FutureBuilder<DetailModel?>(
        future: detailModel,
        builder: (BuildContext context, AsyncSnapshot<DetailModel?> snapshot) {
          if (snapshot.hasData) {
            return SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 150,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          height: 150,
                          child: CachedNetworkImage(
                            key: ValueKey(snapshot.data?.data?.posterUrl ?? ""),
                            fit: BoxFit.fitHeight,
                            // placeholder: (context, url) {
                            //   return Image.asset(
                            //     defaultAssets,
                            //     fit: BoxFit.cover,
                            //   );
                            // },
                            imageUrl: snapshot.data?.data?.posterUrl ?? "",
                            errorWidget: (context, url, error) {
                              return const Center(
                                child: Text("加载失败",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 18,
                                    )),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                gradient: LinearGradient(
                                  stops: [0.6, 0.9],
                                  colors: [Colors.black87, Colors.transparent],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data?.data?.videoName ?? "",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                    child: Text(
                                      _subtitle(snapshot.data),
                                      style: const TextStyle(
                                          color: Colors.white60, fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 85,
                                        height: 45,
                                        child: Button(
                                          text: "播放",
                                          textColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          radius: 5,
                                          textStyle: const TextStyle(
                                              fontSize: 18),
                                          click: () =>
                                          {
                                            //播放
                                            Get.to(
                                                const VideoPage(), arguments: {
                                              "headNo": snapshot.data?.data
                                                  ?.headNo
                                            })
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          _getCollectData(isCollect: snapshot.data?.data?.isCollect == true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(
                                              snapshot.data?.data?.isCollect ??
                                                  false
                                                  ? addedAssets
                                                  : addAssets,
                                              fit: BoxFit.fitHeight,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          _getLikesData(isLike: snapshot.data?.data?.isLike == 1);
                                        },
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            snapshot.data?.data?.isLike == 0
                                                ? unzanAssets
                                                : zanAssets,
                                            fit: BoxFit.fitHeight,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Text(
                      snapshot.data?.data?.intro ?? "",
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?.data?.videoName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          const TextStyle(color: Colors.white70, fontSize: 24),
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 20),
                                width: 120,
                                height: 80,
                                child: CachedNetworkImage(
                                  key: ValueKey(snapshot
                                      .data?.data?.dramaList?.first?.dramaUrl ??
                                      ""),
                                  fit: BoxFit.fitHeight,
                                  // placeholder: (context, url) {
                                  //   return Image.asset(
                                  //     defaultAssets,
                                  //     fit: BoxFit.cover,
                                  //   );
                                  // },
                                  imageUrl: snapshot
                                      .data?.data?.dramaList?.first?.dramaUrl ??
                                      "",
                                  errorWidget: (context, url, error) {
                                    return const Center(
                                      child: Text("加载失败",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 18,
                                          )),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data?.data?.dramaList
                                                ?.first
                                                ?.dramaTitle ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data?.data?.duration ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data?.data?.dramaList?.first
                                            ?.intro ??
                                            "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          onTap: () =>
                          {
                            //播放
                            Get.to(
                                const VideoPage(), arguments: {
                              "headNo": snapshot.data?.data
                                  ?.headNo
                            })
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "影片详情",
                          style: TextStyle(color: Colors.white70, fontSize: 24),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "导演",
                                style:
                                TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.director ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "主演",
                                style:
                                TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.cast ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "标签",
                                style:
                                TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.videoTag?.join(",") ??
                                      "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "类型",
                                style:
                                TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.videoType ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _similarTitleView(snapshot.data)
                ]));
          } else {
            return SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  // const SizedBox(),
                ]));
          }
        });
  }

  Widget _similarTitleView(DetailModel? model) {
    bool state = (model?.data?.similarList?.length ?? 0) > 0;
    if (state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text("更多类似《${model?.data?.videoName}》的影片",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 18,
            )),
      );
    } else {
      return const SizedBox();
    }
  }

  String _subtitle(DetailModel? model) {
    String year = model?.data?.videoDate
        ?.split("-")
        .first ?? "";
    return "$year ${model?.data?.maturity ?? ""} 共 ${model?.data?.setsNumber ??
        1} 集";
  }

  Widget _gridView() {
    return FutureBuilder<DetailModel?>(
      future: detailModel,
      builder: (BuildContext context, AsyncSnapshot<DetailModel?> snapshot) {
        if (snapshot.hasData) {
          return SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                      ),
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: InkWell(
                          child: CachedNetworkImage(
                            key: ValueKey(snapshot.data?.data
                                ?.similarList?[index]?.posterUrl1 ??
                                ''),
                            fit: BoxFit.fitHeight,
                            // placeholder: (context, url) {
                            //   return Image.asset(
                            //     defaultAssets,
                            //     fit: BoxFit.cover,
                            //   );
                            // },
                            imageUrl: snapshot.data?.data?.similarList?[index]
                                ?.posterUrl1 ??
                                '',
                            errorWidget: (context, url, error) {
                              return const Center(
                                child: Text("加载失败",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 18,
                                    )),
                              );
                            },
                          ),
                          onTap: () {
                            //播放
                            Get.to(
                                const VideoPage(), arguments: {
                              "headNo": snapshot.data?.data?.similarList?[index]?.headNo ?? ""
                            });
                          },
                        ),
                      ),
                    );
                  },
                  childCount: snapshot.data?.data?.similarList?.length ?? 0,
                ),
              ));
        } else {
          return SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                const SizedBox(),
              ]));
        }
      },
    );
  }
}
