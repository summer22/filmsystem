import 'package:filmsystem/data/models/code_model.dart';
import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/home.dart';
import 'package:filmsystem/pages/sign_up/sign_up_controller.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/pages/widgets/buttons/count_down_button.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpFour extends StatefulWidget {
  const SignUpFour({super.key});

  @override
  State<SignUpFour> createState() => _SignUpFourState();
}

class _SignUpFourState extends State<SignUpFour> {
  late SignUpController _controller; // 控制器实例
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _showEmailClearButton = false;
  bool _showCodeClearButton = false;
  String smsToken = "";

  @override
  void initState() {
    _controller = Get.find<SignUpController>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void getCodeData(VoidCallback codeCallback) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.code;
    request.add("email", _emailController.text);
    try {
      ApiResponse response = await Api().fire(request);
      CodeModel codeModel = CodeModel.fromJson(response.data);
      smsToken = codeModel.data?.token ?? "";
      codeCallback();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.register;
    request.httpMethod = HttpMethod.post;
    request.add("realName", _controller.name);
    request.add("password", _controller.pwd);
    request.add("comfimPwd", _controller.rePwd);
    request.add("mobile", _controller.mobile);
    request.add("avatarUrl", _controller.avatar);
    request.add(
        "like", _controller.selectedHobbyModel.map((e) => e.headNo).toList());
    request.add("email", _emailController.text);
    request.add("smsCode", _codeController.text);
    request.add("smsToken", smsToken);
    try {
      ApiResponse response = await Api().fire(request);
      getLoginData();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getLoginData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.login;
    request.httpMethod = HttpMethod.post;
    request.add("email", _emailController.text);
    request.add("password", _controller.pwd);
    try {
      ApiResponse response = await Api().fire(request);
      LoginModel loginModel = LoginModel.fromJson(response.data);
      SimpleStorage.write(token, loginModel.data?.token);
      SimpleStorage.remove(account);
      SimpleStorage.remove(pwd);
      getUserInfoData();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getUserInfoData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.userInfo;
    try {
      ApiResponse response = await Api().fire(request);
      UserInfoModel model = UserInfoModel.fromJson(response.data);
      SimpleStorage.write(userInfo, model.data?.toJson());
      _controller.clear();
      Get.offAll(const HomePage());
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
            'step_four'.tr,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'step_four_desc'.tr,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _midInputWidget() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.only(top: 12, right: 15),
                child: Text(
                  'email'.tr,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Expanded(
                  child: TextField(
                cursorColor: Colors.black,
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  hintText: 'email_hint'.tr,
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
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.only(top: 12, right: 15),
                child: Text(
                  'code'.tr,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Expanded(
                child: Row(
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
                        hintText: 'code'.tr,
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
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                        height: 48,
                        width: 130,
                        child: CountDownButton(
                          backgroundColor: Colors.black38,
                          radius: 0,
                          text: 'send_code'.tr,
                          countDownText: 'count_down'.tr,
                          onStart: (VoidCallback callback) {
                            if (_emailController.text.isEmpty) {
                              EasyLoading.showToast('email_hint'.tr);
                              return;
                            }
                            getCodeData(() {
                              callback();
                            });
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _bottomBtn() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
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
                  child: Button(
                text: 'step_four_right_btn'.tr,
                textColor: Colors.white,
                backgroundColor: Colors.redAccent,
                radius: 8,
                textStyle: const TextStyle(fontSize: 15),
                click: () {
                  if (_emailController.text.isEmpty) {
                    EasyLoading.showToast('email_hint'.tr);
                    return;
                  }
                  if (_codeController.text.isEmpty) {
                    EasyLoading.showToast('code_hint'.tr);
                    return;
                  }
                  getData();
                },
              ))
            ],
          )
        ],
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: CustomScrollView(
            slivers: [_topWidget(), _midInputWidget(), _bottomBtn()],
          ),
        ),
      ),
    );
  }
}
