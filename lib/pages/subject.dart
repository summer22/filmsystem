import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/home/home_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final String type = Get.arguments["type"];
  final int classValue = Get.arguments["class"];
  final String title = Get.arguments["title"];

  Future<HomeModel?>? homeModel;
  List<HomeRowItemModel?> list = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int page = 1;
  bool isHasNextPage = false;
  bool isPullDownLoad = false;

  Future<HomeModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.isShowLoading = false;
    request.path = ApiPath.subjectList;
    request.add("pageSize", 20);
    request.add("pageNumber", page);
    request.add("class", classValue);
    request.add("type", type);
    if (page == 1) {
      list = [];
    }
    try {
      ApiResponse response = await Api().fire(request);
      HomeModel model = HomeModel.fromJson(response.data);

      isHasNextPage = model.data?.row?.first?.list?.isEmpty == false &&
          model.data?.row?.first?.list != null;
      list = [...list, ...?model.data?.row?.first?.list];
      model.data?.row?.first?.list = list;

      return Future.value(model);
    } on ApiError catch (e) {
      _refreshController.refreshFailed();
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() async {
    page = 1;
    // _refreshController.resetNoData();
    homeModel = getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!isHasNextPage) {
      _refreshController.loadNoData();
      return;
    }
    page = page + 1;
    homeModel = getData();
    _refreshController.loadComplete();
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
          title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        // const MaterialClassicHeader(
        //   color: Colors.white,
        //   backgroundColor: Colors.white,
        // ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: CustomScrollView(
          slivers: [
            _gridView(),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
    return FutureBuilder<HomeModel?>(
      future: homeModel,
      builder: (BuildContext context, AsyncSnapshot<HomeModel?> snapshot) {
        if (snapshot.hasData) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SizedBox(
                  height: 150,
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: InkWell(
                      child: CachedNetworkImage(
                        key: ValueKey(snapshot.data?.data?.row?.first
                                ?.list?[index]?.posterUrl1 ??
                            ''),
                        fit: BoxFit.fitHeight,
                        // placeholder: (context, url) {
                        //   return Image.asset(
                        //     defaultAssets,
                        //     fit: BoxFit.cover,
                        //   );
                        // },
                        imageUrl: snapshot.data?.data?.row?.first?.list?[index]
                                ?.posterUrl1 ??
                            '',
                        errorWidget: (context, url, error) {
                          return  Center(
                            child: Text('image_loading_error'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                          "headNo": snapshot.data?.data?.row?.first?.list?[index]
                            ?.headNo ?? ""
                        });
                      },
                    ),
                  ),
                );
              },
              childCount: snapshot.data?.data?.row?.first?.list?.length ?? 0,
            ),
          );
        } else {
          return SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Center(
              child: Text(
                'empty'.tr,
                style: const TextStyle(color: Colors.white60),
              ),
            )
          ]));
        }
      },
    );
  }
}
