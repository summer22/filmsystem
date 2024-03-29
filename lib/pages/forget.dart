import 'package:filmsystem/data/models/code_model.dart';
import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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
  String smsToken = "";

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
      SimpleStorage.write(token, loginModel.data?.token);
      SimpleStorage.remove(account);
      SimpleStorage.remove(pwd);
      Get.back();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  void getConfirmData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.forget;
    request.add("smsCode", _codeController.text);
    request.add("email", _controller.text);
    request.add("smsToken", smsToken);
    request.add("password", _pwdController.text);
    try {
      await Api().fire(request);
      SimpleStorage.remove(account);
      SimpleStorage.remove(pwd);
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
      CodeModel codeModel = CodeModel.fromJson(response.data);
      smsToken = codeModel.data?.token ?? "";
      codeCallback();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
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
                    // errorBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.orange),
                    // ),
                    filled: true,
                    fillColor: Colors.white10,
                    // errorText: _validateInput(_controller.text),
                    // errorStyle: const TextStyle(color: Colors.orange),
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
                    // errorBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.orange),
                    // ),
                    filled: true,
                    fillColor: Colors.white10,
                    // errorText: _validatePwdInput(_pwdController.text),
                    // errorStyle: const TextStyle(color: Colors.orange),
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
                    // errorBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.orange),
                    // ),
                    filled: true,
                    fillColor: Colors.white10,
                    // errorText: _validatePwdInput(_pwdTwoController.text),
                    // errorStyle: const TextStyle(color: Colors.orange),
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
                          // errorBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.orange),
                          // ),
                          filled: true,
                          fillColor: Colors.white10,
                          // errorText: _validateCodeInput(_codeController.text),
                          // errorStyle: const TextStyle(color: Colors.orange),
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
                  height: 50,
                  child: Button(
                    text: 'change_pwd'.tr,
                    textColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 18),
                    click: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if(_controller.text.isEmpty){
                        EasyLoading.showToast('email_hint'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if (_pwdController.text.isEmpty ||
                          _pwdController.text.length < 4 ||
                          _pwdController.text.length > 20) {
                        EasyLoading.showToast('pwd_empty_tip'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_pwdTwoController.text != _pwdController.text){
                        EasyLoading.showToast('pwd_diff_tip'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_codeController.text.isEmpty){
                        EasyLoading.showToast('code_hint'.tr,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
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
