import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/news/news_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<NewsModel?>? newsModel;
  late String baseUrl;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() async {
      newsModel = getData();
  }

  Future<NewsModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.newsList;
    baseUrl = request.host();
    try {
      ApiResponse response = await Api().fire(request);
      return Future.value(NewsModel.fromJson(response.data));
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
          'news'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _vListView(),
    );
  }

  Widget _vListView() {
    return FutureBuilder<NewsModel?>(
      future: newsModel,
      builder: (BuildContext context, AsyncSnapshot<NewsModel?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: snapshot.data?.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return _item(snapshot.data?.data?[index]);
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

  Widget _item(NewsItemModel? model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3/2,
            child: InkWell(
              child: CachedNetworkImage(
                key: ValueKey(baseUrl + (model?.cover ?? '')),
                fit: BoxFit.fitWidth,
                // placeholder: (context, url) {
                //   return Image.asset(
                //     defaultAssets,
                //     fit: BoxFit.cover,
                //   );
                // },
                imageUrl: baseUrl + (model?.cover ?? ''),
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
              onTap: () {},
            ),
          ),
          Expanded(child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(model?.msgTitle ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white)),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(model?.msgContent ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white)),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(model?.updateDate ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
