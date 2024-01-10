import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/forget.dart';
import 'package:filmsystem/pages/sign_up/sign_up_one.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool _showClearButton = false;
  bool _showPwdClearButton = false;
  bool _cipherText = true;
  bool _saveAccount = false;

  @override
  void initState() {
    super.initState();
    //如果记住账户了 就自动填充
    if (SimpleStorage.read(account) != null) {
      _controller.text = SimpleStorage.read(account);
    }
    if (SimpleStorage.read(pwd) != null) {
      _pwdController.text = SimpleStorage.read(pwd);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.login;
    request.httpMethod = HttpMethod.post;
    request.add("email", _controller.text);
    request.add("password", _pwdController.text);
    try {
      ApiResponse response = await Api().fire(request);
      LoginModel loginModel = LoginModel.fromJson(response.data);
      SimpleStorage.write(token, loginModel.data?.token);
      SimpleStorage.remove(account);
      SimpleStorage.remove(pwd);
      getUserInfoData();
      if (_saveAccount) {
        SimpleStorage.write(account, _controller.text);
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

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_hint'.tr;
    }
    return null;
  }

  String? _validatePwdInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'pwd_hint'.tr;
    }
    return null;
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
                      color: Colors.orange,
                    )),
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.orange,
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'login'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  cursorColor: Colors.white,
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'email'.tr,
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    errorText: _validateInput(_controller.text),
                    errorStyle: const TextStyle(color: Colors.orange),
                    suffixIcon: _showClearButton
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                _showClearButton = false;
                              });
                            },
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _showClearButton = value.isNotEmpty;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  cursorColor: Colors.white,
                  controller: _pwdController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: _cipherText,
                  decoration: InputDecoration(
                    hintText: 'pwd'.tr,
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    errorText: _validatePwdInput(_pwdController.text),
                    errorStyle: const TextStyle(color: Colors.orange),
                    suffixIcon: _leftIcon(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showPwdClearButton = value.isNotEmpty;
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: Get.width - 40,
                  height: 60,
                  child: Button(
                    text: 'login'.tr,
                    textColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 18),
                    click: () {
                      if(_controller.text.isEmpty){
                        EasyLoading.showToast('email_hint'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_pwdController.text.isEmpty){
                        EasyLoading.showToast('pwd_hint'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      getData();
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                            style: const TextStyle(color: Colors.white, fontSize: 12),
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
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'sign_in_tip'.tr,
                      style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 20,),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignUpOne());
                      },
                      child: Text(
                        'sign_in_btn_title'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
