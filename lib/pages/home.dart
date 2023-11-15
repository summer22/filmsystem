import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:filmsystem/app/app_theme.dart';
import 'package:filmsystem/data/models/home/home_model.dart';
import 'package:filmsystem/data/models/home/lang_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/lang/messages_controller.dart';
import 'package:filmsystem/pages/detail.dart';
import 'package:filmsystem/pages/favorite.dart';
import 'package:filmsystem/pages/help.dart';
import 'package:filmsystem/pages/login.dart';
import 'package:filmsystem/pages/news.dart';
import 'package:filmsystem/pages/search.dart';
import 'package:filmsystem/pages/subject.dart';
import 'package:filmsystem/pages/userinfo.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<HomeModel?>? homeModel;

  String type = "0";

  late List<LangModel> menuItems;
  late List<String> infoItems;

  final box = GetStorage();

  late LangModel selectedModel;
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  final CustomPopupMenuController _personController =
      CustomPopupMenuController();

  MessagesController messagesController = Get.put(MessagesController());

  @override
  void initState() {
    menuItems = [
      LangModel('简体中文', "zh_CN"),
      LangModel('English', "en_US"),
    ];
    if (box.read(token) == null) {
      infoItems = ['help', 'sign_in'];
    } else {
      infoItems = ['account','help','logout'];
    }

    super.initState();

    selectedModel = menuItems.first;
    box.write(i18code, selectedModel.code);
    box.listenKey(i18code, (value) {
      if (value == "zh_CN") {
        messagesController.changeLanguage('zh', "CN");
      } else {
        messagesController.changeLanguage('en', "US");
      }
    });

    box.listenKey(token, (value) {
      type = "0";
      _onRefresh();

      if (value == null) {
        infoItems = ['help', 'sign_in'];
      } else {
        infoItems = ['account','help','logout'];
      }
    });

    _onRefresh();
  }

  void _onRefresh() async {
    setState(() {
      homeModel = getData();
    });
  }

  Future<HomeModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.homeList + type;
    try {
      ApiResponse response = await Api().fire(request);
      return Future.value(HomeModel.fromJson(response.data));
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
              child: Icon(Icons.menu, color: AppTheme.white),
            ),
            onTap: () => Scaffold.of(context).openDrawer(), // 打开抽屉
          ),
        ),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 35),
              child: Icon(Icons.search_rounded, color: AppTheme.white),
            ),
            onTap: () => {Get.to(const SearchPage())},
          ),
          CustomPopupMenu(
            arrowColor: Colors.black38,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.black38,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (item.code != selectedModel.code) {
                                setState(() {
                                  selectedModel = item;
                                  box.write(i18code, selectedModel.code);
                                  _onRefresh();
                                });
                              }
                              _controller.hideMenu();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: 1,
            controller: _controller,
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black38,
                border: Border.all(
                  color: Colors.black38, // 设置边框颜色
                  width: 0.5, // 设置边框宽度
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white12, // 设置阴影颜色
                    blurRadius: 1.0, // 设置阴影模糊程度
                  ),
                ],
                borderRadius: BorderRadius.circular(5.0), // 设置圆角
              ),
              child: Row(
                children: [
                   Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(searchGlobalAssets, color: Colors.white70),
                  ),
                  Text(
                    selectedModel.title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.arrow_drop_down, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.add_alert_sharp, color: AppTheme.white),
            ),
            onTap: () => {Get.to(const NewsPage())},
          ),
          CustomPopupMenu(
            arrowColor: Colors.black38,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.black38,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: infoItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _personController.hideMenu();
                              switch (item) {
                                case "sign_in":
                                  Get.to(const LoginPage());
                                  break;
                                case "account":
                                  Get.to(const UserInfoPage());
                                  break;
                                case "help":
                                  Get.to(const HelpPage());
                                  break;
                                case "logout":
                                  box.remove(userInfo);
                                  box.remove(token);
                                  break;
                                default:
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                item.tr,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: 1,
            controller: _personController,
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.person, color: AppTheme.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        width: 200,
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            color: Colors.white12,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.only(top: Get.statusBarHeight),
                height: 190,
                child: Center(
                  child: Image.asset(logoAssets),
                ),
              ),
              ListTile(
                title: Text(
                  'home'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  type = "0";
                  _onRefresh();
                  Navigator.pop(context);
                },
              ),
             ListTile(
            title: Text(
              'show'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              type = "2";
              _onRefresh();
              Navigator.pop(context);
            },
          ),
              ListTile(
                title: Text(
                  'movie'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  type = "1";
                  _onRefresh();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'hot'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  type = "4";
                  _onRefresh();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'favorite'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(const FavoritePage());
                },
              ),
            ],
          ),
        ),

      ),
      body: _vListView(),
    );
  }

  Widget _vListView() {
    return FutureBuilder<HomeModel?>(
      future: homeModel,
      builder: (BuildContext context, AsyncSnapshot<HomeModel?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.data?.row?.length ?? 0, // 你的列表项数量
            itemBuilder: (BuildContext context, int index) {
              return _hListView(snapshot.data?.data?.row?[index],
                  snapshot.data?.data?.row?[index]?.title);
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _hListView(HomeRowModel? model, String? title) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 90,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => {
              Get.to(const SubjectPage(), arguments: {
                "class": model?.classValue,
                "type": type,
                "title": model?.title
              })
            },
            child: Text(title ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model?.list?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Colors.white12,
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 5, //横纵比 长宽比  3:2
                  child: InkWell(
                    child: CachedNetworkImage(
                      key: ValueKey(model?.list?[index]?.posterUrl2 ?? ''),
                      fit: BoxFit.fitHeight,
                      // placeholder: (context, url) {
                      //   return Image.asset(
                      //     defaultAssets,
                      //     fit: BoxFit.contain,
                      //   );
                      // },
                      imageUrl: model?.list?[index]?.posterUrl2 ?? '',
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
                      Get.to(const DetailPage(), arguments: {
                        "title": model?.list?[index]?.videoName,
                        "headNo": model?.list?[index]?.headNo
                      });
                    },
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _personController.dispose();
    super.dispose();
  }
}