import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/info/avatar_list_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/sign_up/sign_up_controller.dart';
import 'package:filmsystem/pages/sign_up/sign_up_three.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({super.key});

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  late SignUpController _controller; // 控制器实例

  AvatarListModel? avatarListModel;

  String selectedAvatar = "";
  late String baseUrl;
  int selectedIndex = -1;

  @override
  void initState() {
    _controller = Get.find<SignUpController>();
    super.initState();
    getData();
  }

  void getData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.avatarList;
    baseUrl = request.host();
    try {
      ApiResponse response = await Api().fire(request);
      setState(() {
        avatarListModel = AvatarListModel.fromJson(response.data);
      });
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  SliverToBoxAdapter _topWidget() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'step_two'.tr,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${_controller.name}，${'step_two_subtitle'.tr}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              text: 'step_two_desc1'.tr,
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'step_two_desc2'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SliverGrid _sliverGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                selectedAvatar = avatarListModel?.data?[index]?.url ?? "";
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: selectedIndex == index
                    ? Border.all(color: Colors.green, width: 2.0)
                    : null,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: CachedNetworkImage(
                key: ValueKey(
                    baseUrl + (avatarListModel?.data?[index]?.url ?? "")),
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const SizedBox(),
                  );
                },
                imageUrl: baseUrl + (avatarListModel?.data?[index]?.url ?? ""),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // 设置圆角半径
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('image_loading_error'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          )),
                    ),
                  );
                },
              ),
            ),
          );
        },
        childCount: avatarListModel?.data?.length ?? 0,
      ),
    );
  }

  Widget _bottom() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 30,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  child: Button(
                    text: 'step_two_btn_left'.tr,
                    textColor: Colors.black87,
                    backgroundColor: Colors.white70,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 15),
                    click: () {
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Button(
                      text: selectedAvatar.isEmpty ? "step_two_btn_right1".tr : 'step_two_btn_right2'.tr ,
                      textColor: selectedAvatar.isEmpty ? Colors.black87 : Colors.white,
                      backgroundColor: selectedAvatar.isEmpty ? Colors.white70 : Colors.redAccent,
                      radius: 8,
                      textStyle: const TextStyle(fontSize: 15),
                      click: () {
                        if(selectedAvatar.isEmpty){
                          return;
                        }
                        _controller.avatar = selectedAvatar;
                        Get.to(() => const SignUpThree());
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              onTap: () => Get.back()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: CustomScrollView(
          slivers: [
            _topWidget(),
            _sliverGrid(),
          ],
        ),
      ),
      bottomNavigationBar: _bottom(),
    );
  }
}
