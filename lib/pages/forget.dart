import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'widgets/buttons/count_down_button.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdTwoController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _showClearButton = false;
  bool _showPwdClearButton = false;
  bool _showPwdTwoClearButton = false;
  bool _showCodeClearButton = false;
  bool _cipherText = true;
  bool _cipherTextTwo = true;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pwdController.dispose();
    _pwdTwoController.dispose();
    _codeController.dispose();
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
      box.write(token, loginModel.data?.token);
      box.remove(account);
      box.remove(pwd);
      // getUserInfoData();
      // if (_saveAccount) {
      //   box.write(account, _controller.text);
      //   box.write(pwd, _pwdController.text);
      // }
      Get.back();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getConfirmData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.forget;
    request.add("code", _codeController.text);
    request.add("email", _controller.text);
    request.add("Reconfirmpassword", _pwdTwoController.text);
    request.add("password", _pwdController.text);
    try {
      ApiResponse response = await Api().fire(request);
      box.remove(account);
      box.remove(pwd);
      Get.back();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getCodeData(VoidCallback codeCallback) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.code;
    request.add("email", _controller.text);
    try {
      ApiResponse response = await Api().fire(request);
      codeCallback();
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

  String? _validateCodeInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'code_hint'.tr;
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

  Widget? _leftTwoIcon() {
    return _showPwdTwoClearButton
        ? SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _cipherTextTwo = !_cipherTextTwo;
                });
              },
              icon: Icon(
                _cipherTextTwo ? Icons.visibility_off : Icons.visibility,
                color: Colors.orange,
              )),
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.orange,
            ),
            onPressed: () {
              setState(() {
                _pwdTwoController.clear();
                _showPwdTwoClearButton = false;
              });
            },
          )
        ],
      ),
    )
        : null;
  }

  Widget? _codeLeftIcon() {
    return _showCodeClearButton
        ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.orange,
            ),
            onPressed: () {
              setState(() {
                _codeController.clear();
                _showCodeClearButton = false;
              });
            },
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
                  'forget_pwd'.tr,
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
                  // onSubmitted: (value) {
                  //   print('Input submitted: $value');
                  // },
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
                  // onSubmitted: (value) {
                  //   print('Input submitted: $value');
                  // },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  cursorColor: Colors.white,
                  controller: _pwdTwoController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: _cipherTextTwo,
                  decoration: InputDecoration(
                    hintText: 'pwd_again'.tr,
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
                    errorText: _validatePwdInput(_pwdTwoController.text),
                    errorStyle: const TextStyle(color: Colors.orange),
                    suffixIcon: _leftTwoIcon(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showPwdTwoClearButton = value.isNotEmpty;
                    });
                  },
                  // onSubmitted: (value) {
                  //   print('Input submitted: $value');
                  // },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: _codeController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'code'.tr,
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
                          errorText: _validateCodeInput(_codeController.text),
                          errorStyle: const TextStyle(color: Colors.orange),
                          suffixIcon: _codeLeftIcon(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showCodeClearButton = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 64,
                        child: CountDownButton(
                          text: 'send_code'.tr,
                          countDownText: 'count_down'.tr,
                          onStart: (VoidCallback callback) {
                            if(_controller.text.isEmpty){
                              EasyLoading.showToast('email_hint'.tr);
                              return;
                            }
                            getCodeData((){
                              callback();
                            });
                          },
                        ))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: Get.width - 40,
                  height: 60,
                  child: Button(
                    text: 'change_pwd'.tr,
                    textColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 18),
                    click: () {
                      getConfirmData();
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
