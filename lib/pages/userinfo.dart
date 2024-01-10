import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/info/avatar_list_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/login.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/pages/widgets/buttons/count_down_button.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _realNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _showMobileClearButton = false;
  bool _showNameClearButton = false;
  bool _showEmailClearButton = false;
  bool _showPwdClearButton = false;
  bool _showCodeClearButton = false;
  bool _cipherText = true;

  AvatarListModel? avatarListModel;

  String selectedAvatar = "";
  late String baseUrl;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedAvatar = SimpleStorage.readUserInfo().data?.avatar ?? "";
    _mobileController.text = SimpleStorage.readUserInfo().data?.mobile ?? "";
    _realNameController.text = SimpleStorage.readUserInfo().data?.realName ?? "";
    _emailController.text = SimpleStorage.readUserInfo().data?.email ?? "";
    getData();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _realNameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _codeController.dispose();
    super.dispose();
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

  void updateInfoData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.updateUserInfo;
    request.add("avatar", request.host() + selectedAvatar);
    request.add("realName", _realNameController.text);
    request.add("email", _emailController.text);
    request.add("password", _pwdController.text);
    request.add("mobile", _mobileController.text);
    request.add("smsCode", _codeController.text);
    try {
      await Api().fire(request);
      SimpleStorage.removeUserInfo();
     Get.off(const LoginPage());
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getCodeData(VoidCallback codeCallback) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.code;
    request.add("email", _emailController.text);
    try {
      await Api().fire(request);
      codeCallback();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              onTap: () => Get.back()),
        ),
        title: Text(
          'update_info_title'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // 当用户点击 CustomScrollView 时，关闭键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'update_info_current_avatar'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CachedNetworkImage(
                      width: 80,
                      height: 80,
                      key: ValueKey(selectedAvatar),
                      fit: BoxFit.fitHeight,
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
                      placeholder: (context, url) {
                        return Container(
                          // width: 80,
                          // height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                      imageUrl: selectedAvatar,
                      errorWidget: (context, url, error) {
                        return Container(
                          // width: 80,
                          // height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'update_info_optional_avatar'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          selectedAvatar = baseUrl +
                              (avatarListModel?.data?[index]?.url ?? "");
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
                          key: ValueKey(baseUrl +
                              (avatarListModel?.data?[index]?.url ?? "")),
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
                          imageUrl: baseUrl +
                              (avatarListModel?.data?[index]?.url ?? ""),
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
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.black12,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'update_info_user_base_info'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'update_info_mobile'.tr,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          cursorColor: Colors.black,
                          controller: _mobileController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            hintText: 'update_info_mobile'.tr,
                            hintStyle: const TextStyle(color: Colors.black45),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: _validateInput(_mobileController.text),
                            errorStyle:
                                const TextStyle(color: Colors.redAccent),
                            suffixIcon: _showMobileClearButton
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _mobileController.clear();
                                        _showMobileClearButton = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              _showMobileClearButton = value.isNotEmpty;
                            });
                          },
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'update_info_real_name'.tr,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: _realNameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                hintText: 'update_info_real_name'.tr,
                                hintStyle: const TextStyle(color: Colors.black45),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: _validateInput(_realNameController.text),
                                errorStyle:
                                const TextStyle(color: Colors.redAccent),
                                suffixIcon: _showNameClearButton
                                    ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _realNameController.clear();
                                      _showNameClearButton = false;
                                    });
                                  },
                                )
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showNameClearButton = value.isNotEmpty;
                                });
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'update_info_email'.tr,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                hintText: 'update_info_email'.tr,
                                hintStyle: const TextStyle(color: Colors.black45),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: _validateInput(_emailController.text),
                                errorStyle:
                                const TextStyle(color: Colors.redAccent),
                                suffixIcon: _showEmailClearButton
                                    ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _emailController.clear();
                                      _showEmailClearButton = false;
                                    });
                                  },
                                )
                                    : null,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {
                                  _showEmailClearButton = value.isNotEmpty;
                                });
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'update_info_password'.tr,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              obscureText: _cipherText,
                              cursorColor: Colors.black,
                              controller: _pwdController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                hintText: 'update_info_password'.tr,
                                hintStyle: const TextStyle(color: Colors.black45),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: _validateInput(_pwdController.text),
                                errorStyle:
                                const TextStyle(color: Colors.redAccent),
                                suffixIcon: _leftIcon(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showPwdClearButton = value.isNotEmpty;
                                });
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'update_info_sms_code'.tr,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextField(
                                  cursorColor: Colors.black,
                                  controller: _codeController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    hintText: 'update_info_sms_code'.tr,
                                    hintStyle: const TextStyle(color: Colors.black45),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    errorText: _validateInput(_codeController.text),
                                    errorStyle:
                                    const TextStyle(color: Colors.redAccent),
                                    suffixIcon: _showCodeClearButton
                                        ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _codeController.clear();
                                          _showCodeClearButton = false;
                                        });
                                      },
                                    )
                                        : null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _showCodeClearButton = value.isNotEmpty;
                                    });
                                  },
                                )),
                            const SizedBox(width: 5,),
                            SizedBox(
                                height: 48,
                                width: 130,
                                child: CountDownButton(
                                  backgroundColor: Colors.black38,
                                  radius: 0,
                                  text: 'send_code'.tr,
                                  countDownText: 'count_down'.tr,
                                  onStart: (VoidCallback callback) {
                                    if(_emailController.text.isEmpty){
                                      EasyLoading.showToast('email_hint'.tr);
                                      return;
                                    }
                                    getCodeData((){
                                      callback();
                                    });
                                  },
                                ))
                          ],
                        ),),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.black12,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button(text: 'update_info_clear'.tr, textColor: Colors.black54, backgroundColor: Colors.white, borderWidth: 2, borderColor: Colors.black38,  click: (){
                          _mobileController.clear();
                          _realNameController.clear();
                          _emailController.clear();
                          _pwdController.clear();
                          _codeController.clear();
                          _showMobileClearButton = false;
                          _showNameClearButton = false;
                          _showEmailClearButton = false;
                          _showPwdClearButton = false;
                          _showCodeClearButton = false;
                        }),
                        const SizedBox(width: 40,),
                        Button(text: 'update_info_submit'.tr, textColor: Colors.white, backgroundColor: Colors.black54, click: (){
                          if(_mobileController.text.isEmpty){
                            EasyLoading.showToast('mobile_hint'.tr,
                                toastPosition: EasyLoadingToastPosition.bottom);
                            return;
                          }
                          if(_realNameController.text.isEmpty){
                            EasyLoading.showToast('name_hint'.tr,
                                toastPosition: EasyLoadingToastPosition.bottom);
                            return;
                          }
                          if(_emailController.text.isEmpty){
                            EasyLoading.showToast('email_hint'.tr,
                                toastPosition: EasyLoadingToastPosition.bottom);
                            return;
                          }
                          if(_pwdController.text.isEmpty){
                            EasyLoading.showToast('pwd_hint'.tr,
                                toastPosition: EasyLoadingToastPosition.bottom);
                            return;
                          }
                          if(_codeController.text.isEmpty){
                            EasyLoading.showToast('code_hint'.tr,
                                toastPosition: EasyLoadingToastPosition.bottom);
                            return;
                          }
                          updateInfoData();
                        },),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _leftIcon() {
    return _showPwdClearButton
        ? SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _cipherText = !_cipherText;
                });
              },
              icon: Icon(
                _cipherText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              )),
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _pwdController.clear();
                _showPwdClearButton = false;
              });
            },
          )
        ],
      ),
    )
        : null;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'update_info_hint'.tr;
    }
    return null;
  }
}
