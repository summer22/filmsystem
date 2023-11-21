import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/search/search_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/pages/widgets/standard_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Future<SearchModel?>? searchModel;

  late String input;

  Future<SearchModel?> getData(String text) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.searchList;
    request.add("searchTitle", text);
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
        title: StandardSearchBarInner(
          hint: 'search_hint'.tr,
          callback: (text) async {
            if (text.isNotEmpty) {
              input = text;
              setState(() {
                searchModel = getData(text);
              });
            }
          },
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'cancel'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              onTap: () => Get.back()),
        ],
      ),
      body: FutureBuilder<SearchModel?>(
        future: searchModel,
        builder: (BuildContext context, AsyncSnapshot<SearchModel?> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  child: Text(
                    'search_result_tip'.tr + _name(snapshot.data!.data!),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(
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
                              // placeholder: (context, url) {
                              //   return Image.asset(
                              //     defaultAssets,
                              //     fit: BoxFit.cover,
                              //   );
                              // },
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
                            onTap: () {
                              //播放
                              Get.to(() => const VideoPage(), arguments: {
                                "headNo": snapshot.data?.data?[index]?.headNo ?? ""
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  String _name(List<SearchItemModel?> data) {
    String value = data.map((item) => item?.videoName).toList().join(' ');
    if(value.isNotEmpty){
      return value;
    }
    return input;
  }
}
