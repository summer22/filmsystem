import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/forget.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'sign_up/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool _showEmailClearButton = false;
  bool _showPwdClearButton = false;
  bool _cipherText = true;
  bool _saveAccount = false;

  @override
  void initState() {
    super.initState();
    if (SimpleStorage.read(account) != null) {
      _emailController.text = SimpleStorage.read(account);
    }
    if (SimpleStorage.read(pwd) != null) {
      _pwdController.text = SimpleStorage.read(pwd);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.login;
    request.httpMethod = HttpMethod.post;
    request.add("email", _emailController.text);
    request.add("password", _pwdController.text);
    try {
      ApiResponse response = await Api().fire(request);
      LoginModel loginModel = LoginModel.fromJson(response.data);
      SimpleStorage.write(token, loginModel.data?.token);
      SimpleStorage.remove(account);
      SimpleStorage.remove(pwd);
      getUserInfoData();
      if (_saveAccount) {
        SimpleStorage.write(account, _emailController.text);
        SimpleStorage.write(pwd, _pwdController.text);
      }
      Get.back();
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
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  _rightIcon() {
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
                size: 20,
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

  _topWidget() {
    return Builder(
      builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 22, top: 50),
          child: GestureDetector(
              child: Image.asset(logoAssets,
                  height: 30,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft),
              onTap: () => Get.back())),
    );
  }

  _contentWidget() {
    return Container(
      width: Get.width - 44,
      margin: EdgeInsets.only(left: 22, right: 22, top: Get.height * 0.15),
      padding: const EdgeInsets.only(left: 22, right: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black87,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              'login'.tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child:  TextField(
              cursorColor: Colors.black,
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 10),
                hintText: 'email'.tr,
                hintStyle: const TextStyle(color: Colors.black45),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: _showEmailClearButton
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 20,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              obscureText: _cipherText,
              cursorColor: Colors.black,
              controller: _pwdController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 10),
                hintText: 'pwd'.tr,
                hintStyle: const TextStyle(color: Colors.black45),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: _rightIcon(),
              ),
              onChanged: (value) {
                setState(() {
                  _showPwdClearButton = value.isNotEmpty;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 36),
            child:  SizedBox(
              width: Get.width - 88,
              height: 44,
              child: Button(
                text: 'login'.tr,
                textColor: Colors.black,
                backgroundColor: const Color(0xFF27D7F6),
                radius: 8,
                textStyle: const TextStyle(fontSize: 15),
                click: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_emailController.text.isEmpty) {
                    EasyLoading.showToast('email_hint'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
                  if (_pwdController.text.isEmpty ||
                      _pwdController.text.length < 8 ||
                      _pwdController.text.length > 20) {
                    EasyLoading.showToast('pwd_hint'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
                  getData();
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _saveAccount = !_saveAccount;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _saveAccount
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: Colors.white70,
                    ),
                    // Leading icon
                    const SizedBox(width: 8.0),
                    // Adjust spacing between icon and text
                    Text(
                      'remember'.tr,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                    // Trailing text
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ForgetPage());
                },
                child: Text(
                  'forget_pwd'.tr,
                  style:
                  const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'sign_in_tip'.tr,
                style: const TextStyle(
                  color: Colors.white30,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const SignUpPage());
                  // Get.to(() => const SignUpOne());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'sign_in_btn_title'.tr,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              signUpBgAssets,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_topWidget(), _contentWidget()],
            ),
          ),
        ),
      ),
    );
  }
}
