import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/search/search_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  Future<SearchModel?>? searchModel;

  late String input;

  Future<SearchModel?> getData(String text) async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.favoriteList;
    try {
      ApiResponse response = await Api().fire(request);
      return Future.value(SearchModel.fromJson(response.data));
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'favorite'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<SearchModel?>(
        future: searchModel,
        builder: (BuildContext context, AsyncSnapshot<SearchModel?> snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                // 横轴子元素数量
                mainAxisSpacing: 10.0,
                // 主轴间距
                crossAxisSpacing: 10.0,
                // 横轴间距
                padding: const EdgeInsets.all(10.0),
                // 内边距
                children: List.generate(snapshot.data?.data?.length ?? 0,
                        (index) {
                      return SizedBox(
                        height: 150,
                        child: AspectRatio(
                          aspectRatio: 4 / 5,
                          child: InkWell(
                            child: CachedNetworkImage(
                              key: ValueKey(
                                  snapshot.data?.data?[index]?.posterUrl1 ??
                                      ''),
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) {
                                return Image.asset(
                                  defaultAssets,
                                  fit: BoxFit.cover,
                                );
                              },
                              imageUrl:
                              snapshot.data?.data?[index]?.posterUrl1 ?? '',
                              errorWidget: (context, url, error) {
                                return  Center(
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
                      );
                    }),
              ),
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
      ),
    );
  }

}
