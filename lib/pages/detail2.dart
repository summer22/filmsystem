import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/detail/detail_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/detail.dart';
import 'package:filmsystem/pages/login.dart';
import 'package:filmsystem/pages/webiew.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'widgets/buttons/button.dart';

class DetailPage2 extends StatefulWidget {
  const DetailPage2({super.key});

  @override
  State<DetailPage2> createState() => _DetailPage2State();
}

class _DetailPage2State extends State<DetailPage2> {
  final String title = Get.arguments["title"];
  final String headNo = Get.arguments["headNo"];

  Future<DetailModel?>? detailModel;
  DetailModel? recordDetailModel;
  late String baseUrl;
  final box = GetStorage();

  Future<DetailModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.detail;
    request.add("headNo", headNo);
    baseUrl = request.host();
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
    request.path = isCollect ? ApiPath.delete : ApiPath.insert;
    request.add("headNo", headNo);
    try {
      await Api().fire(request);
      recordDetailModel?.data?.isCollect = !isCollect;
      setState(() {
        detailModel = Future.value(recordDetailModel);
      });
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
    request.add("isLike", isLike ? 0 : 1);
    try {
      await Api().fire(request);
      recordDetailModel?.data?.isLike = isLike ? 0 : 1;
      setState(() {
        detailModel = Future.value(recordDetailModel);
      });
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
      backgroundColor: Colors.black,
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
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              return Center(
                                child: Text('image_loading_error'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data?.data?.videoName ?? "",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                    child: Text(
                                      _subtitle(snapshot.data),
                                      style: const TextStyle(
                                          color: Colors.white60, fontSize: 14),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        height: 32,
                                        child: Button(
                                          text: 'play'.tr,
                                          textColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          radius: 5,
                                          textStyle: const TextStyle(fontSize: 13),
                                          click: () => {
                                            //播放
                                            Get.to(() => WebViewScreen(
                                              url:
                                              "${baseUrl}watch?url=${snapshot.data?.data?.filmUrl}&videoName=${snapshot.data?.data?.videoName}&headNo=${snapshot.data?.data?.headNo}",
                                            ))
                                            // Get.to(() => const VideoPage(),
                                            //     arguments: {
                                            //       "headNo":
                                            //           snapshot.data?.data?.headNo
                                            //     })
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (box.read(token) == null) {
                                            Get.to(() => const LoginPage());
                                            return;
                                          }
                                          _getCollectData(
                                              isCollect:
                                              snapshot.data?.data?.isCollect ==
                                                  true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: SizedBox(
                                            width: 35,
                                            height: 35,
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
                                        onTap: () {
                                          if (box.read(token) == null) {
                                            Get.to(() => const LoginPage());
                                            return;
                                          }
                                          _getLikesData(
                                              isLike:
                                              snapshot.data?.data?.isLike == 1);
                                        },
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      snapshot.data?.data?.intro ?? "",
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?.data?.videoName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          const TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        for (int index = 0;
                        index < (snapshot.data?.data?.dramaList?.length ?? 0);
                        index++)
                          GestureDetector(
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        "${snapshot.data?.data?.dramaList?[index]?.dramaNumber}",
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      const EdgeInsets.only(top: 10, right: 20),
                                      width: 120,
                                      height: 80,
                                      child: CachedNetworkImage(
                                        key: ValueKey(snapshot.data?.data
                                            ?.dramaList?[index]?.dramaUrl ??
                                            ""),
                                        fit: BoxFit.cover,
                                        // placeholder: (context, url) {
                                        //   return Image.asset(
                                        //     defaultAssets,
                                        //     fit: BoxFit.cover,
                                        //   );
                                        // },
                                        imageUrl: snapshot.data?.data
                                            ?.dramaList?[index]?.dramaUrl ??
                                            "",
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Text('image_loading_error'.tr,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 15,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data?.data?.dramaList?[index]
                                                    ?.dramaTitle ??
                                                    "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              "${snapshot.data?.data?.dramaList?[index]?.duration}分钟",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data?.data?.dramaList?[index]
                                              ?.intro ??
                                              "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 12),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            onTap: () => {
                              //播放
                              Get.to(() => WebViewScreen(
                                url:
                                "${baseUrl}watch?url=${snapshot.data?.data?.dramaList?[index]?.filmUrl}&headNo=${snapshot.data?.data?.dramaList?[index]?.headNo}&dramaNumber=${snapshot.data?.data?.dramaList?[index]?.dramaNumber}",
                              ))
                              // Get.to(() => const VideoPage(), arguments: {
                              //   "headNo": snapshot.data?.data?.dramaList?[index]
                              //       ?.headNo
                              // })
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'video_detail'.tr,
                          style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'director'.tr,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.director ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                              Text(
                                'cast'.tr,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.cast ?? "",
                                  maxLines: 3,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                              Text(
                                'tag'.tr,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.videoTag?.join(",") ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                              Text(
                                'story'.tr,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  snapshot.data?.data?.videoType ?? "",
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
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
        child: Text(
            "${'detail_like'.tr}《${model?.data?.videoName}》${'detail_like_movie'.tr}",
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
    String year = model?.data?.videoDate?.split("-").first ?? "";
    return "$year ${model?.data?.maturity ?? ""} ${'detail_total'.tr} ${model?.data?.setsNumber ?? 1} ${'detail_collect'.tr}";
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
                            fit: BoxFit.cover,
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
                              return Center(
                                child: Text('image_loading_error'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
                                    )),
                              );
                            },
                          ),
                          onTap: () {
                            Get.to(() => const DetailPage(), arguments: {
                              "title": snapshot.data?.data?.similarList?[index]
                                  ?.videoName ??
                                  "",
                              "headNo": snapshot.data?.data?.similarList?[index]
                                  ?.headNo ??
                                  ""
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
