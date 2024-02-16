import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/info/avatar_list_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/my/birthday.dart';
import 'package:filmsystem/pages/my/mobile.dart';
import 'package:filmsystem/pages/my/nickname.dart';
import 'package:filmsystem/pages/my/password.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/avatar_item.dart';
import 'sex.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AvatarListModel? avatarListModel;

  String selectedAvatar = "";
  late String baseUrl;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedAvatar = SimpleStorage.readUserInfo().avatar ?? "";
    baseUrl = BaseRequest().host();
    getAvatarData();
    SimpleStorage.box?.listenKey(userInfo, (value) {
      setState(() {
        selectedAvatar = SimpleStorage.readUserInfo().avatar ?? "";
      });
    });
  }

  void getAvatarData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.avatarList;
    request.isShowLoading = false;
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

  void updateInfoData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.updateUserInfo;
    request.add("avatar", selectedAvatar);
    // request.add("realName", _realNameController.text);
    // request.add("email", _emailController.text);
    // request.add("password", _pwdController.text);
    // request.add("mobile", _mobileController.text);
    // request.add("smsCode", _codeController.text);
    // request.add("smsToken", smsToken);
    try {
      await Api().fire(request);
      SimpleStorage.removeUserInfo();

    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  ///头像选择列表弹框
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFF1F2F3),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 410,
                padding: const EdgeInsets.only(left: 15, right: 15),
                width: Get.width,
                child: _gridView(state),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: Get.width - 30,
                    child: Center(
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(
                            color: Color(0xFF27D7F6), fontSize: 20),
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        });
      },
    );
  }

  ///头像列表
  _gridView(StateSetter state) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20.0, top: 15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1),
      itemCount: avatarListModel?.data?.length ?? 0,
      itemBuilder: (context, index) {
        return AvatarItem(
          onSelected: (int select) {
            state(() {
              selectedIndex = select;
            });
            setState(() {
              selectedAvatar = avatarListModel?.data?[select]?.url ?? "";
            });
            Navigator.pop(context);
          },
          baseUrl: baseUrl,
          index: index,
          url: avatarListModel?.data?[index]?.url ?? "",
          isSelected: index == selectedIndex,
        );
      },
    );
  }

  _mobileNumber() {
    String code = ((SimpleStorage.readUserInfo().callingCode?.length ?? 0) > 0) ? "+${SimpleStorage.readUserInfo().callingCode}" : "";
    return code + (SimpleStorage.readUserInfo().mobile ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.grey),
              ),
              onTap: () => Get.back()),
        ),
        title: Text(
          'update_info_title'.tr,
          style: const TextStyle(
              color: Color(0xFF3D3D3D),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'avatar'.tr,
                    style:
                        const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 60,
                          height: 60,
                          key: ValueKey(baseUrl + selectedAvatar),
                          fit: BoxFit.fitHeight,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8D8D8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                          imageUrl: baseUrl + selectedAvatar,
                          errorWidget: (context, url, error) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8D8D8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Divider(
                color: Color(0xFFD8D8D8),
                height: 1,
                indent: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const NickNamePage());
              },
              child: Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'nick_name_title'.tr,
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          SimpleStorage.readUserInfo().nickname ?? "",
                          style: const TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 14),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Divider(
                color: Color(0xFFD8D8D8),
                height: 1,
                indent: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const SexPage());
              },
              child: Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "sex".tr,
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          genderList[SimpleStorage.readUserInfo().gender ?? 0],
                          style: const TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 14),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Divider(
                color: Color(0xFFD8D8D8),
                height: 1,
                indent: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const BirthdayPage());
              },
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "birthday".tr,
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          SimpleStorage.readUserInfo().Birthday ?? "",
                          style: const TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 14),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Divider(
                color: Color(0xFFD8D8D8),
                height: 1,
                indent: 18,
              ),
            ),
            GestureDetector(
          onTap: () {
            Get.to(() => const MobilePage());
          },
          child:  Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'phone_number'.tr,
                  style:
                  const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                ),
                Row(
                  children: [
                    Text(
                      _mobileNumber(),
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.arrow_forward_ios,
                          size: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'email_title'.tr,
                    style:
                        const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                  ),
                  Text(
                    SimpleStorage.readUserInfo().email ?? "",
                    style:
                        const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const PasswordPage());
              },
              child: Container(
                  width: Get.width,
                  height: 44,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Text(
                      'update_password'.tr,
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                SimpleStorage.removeUserInfo();
                Get.back();
              },
              child: Container(
                  width: Get.width,
                  height: 44,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Text(
                      'logout'.tr,
                      style: const TextStyle(
                          color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
