import 'package:filmsystem/data/models/code_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/widgets/buttons/count_down_button.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {

  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _repwdController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _showPwdClearButton = false;
  bool _showRepwdClearButton = false;
  bool _repwdCipherText = true;
  bool _showCodeClearButton = false;
  bool _cipherText = true;
  String smsToken = "";

  @override
  void dispose() {
    _pwdController.dispose();
    _repwdController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void getCodeData(VoidCallback codeCallback) async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.code;
    request.add("email", SimpleStorage.readUserInfo().email ?? "");
    try {
      ApiResponse response = await Api().fire(request);
      CodeModel codeModel = CodeModel.fromJson(response.data);
      smsToken = codeModel.data?.token ?? "";
      codeCallback();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  Widget? _rightIcon() {
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

  Widget? _repwdRightIcon() {
    return _showRepwdClearButton
        ? SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _repwdCipherText = !_repwdCipherText;
                });
              },
              icon: Icon(
                _repwdCipherText
                    ? Icons.visibility_off
                    : Icons.visibility,
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
                _repwdController.clear();
                _showRepwdClearButton = false;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
          actions: [
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Text(
                    'save'.tr,
                    style: const TextStyle(
                        color: Color(0xFF3D3D3D),
                        fontSize: 14),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(_pwdController.text.isEmpty || _pwdController.text.length < 8 || _pwdController.text.length > 20){
                    EasyLoading.showToast('pwd_hint'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
                  if(_repwdController.text.isEmpty || _repwdController.text.length < 8 || _repwdController.text.length > 20){
                    EasyLoading.showToast('pwd_hint'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
                  if(_pwdController.text != _repwdController.text){
                    EasyLoading.showToast('pwd_diff_tip'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
                  if (_codeController.text.isEmpty) {
                    EasyLoading.showToast('code_hint'.tr);
                    return;
                  }
                }),
          ],
          title: Text(
            'update_password'.tr,
            style: const TextStyle(
                color: Color(0xFF3D3D3D),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 14
                          ),
                          obscureText: _cipherText,
                          cursorColor: Colors.black,
                          controller: _pwdController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0),
                            hintText: 'pwd'.tr,
                            hintStyle: const TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                            suffixIcon: _rightIcon(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showPwdClearButton = value.isNotEmpty;
                            });
                          },
                        ),
                      )),
                  const SizedBox(
                    width: 50,
                  ),
                  Text(
                    'new_password'.tr,
                    style:
                    const TextStyle(color: Color(0xFFA1A1A1), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          obscureText: _repwdCipherText,
                          cursorColor: Colors.black,
                          controller: _repwdController,
                          style: const TextStyle(
                              fontSize: 14
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0),
                            hintText: 'pwd_again'.tr,
                            hintStyle: const TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                            suffixIcon: _repwdRightIcon(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showRepwdClearButton = value.isNotEmpty;
                            });
                          },
                        ),
                      )),
                  const SizedBox(
                    width: 50,
                  ),
                  Text(
                    'confirm_password'.tr,
                    style:
                    const TextStyle(color: Color(0xFFA1A1A1), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(left: 18),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        controller: _codeController,
                        style: const TextStyle(
                            fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0),
                          hintText: 'code'.tr,
                          hintStyle: const TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          suffixIcon: _showCodeClearButton
                              ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 20,
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
                      width: 100,
                      child: CountDownButton(
                        backgroundColor: const Color(0xFF27D7F6),
                        textColor: Colors.black,
                        disableTextColor: Colors.black,
                        radius: 4,
                        text: 'send_code'.tr,
                        countDownText: 'count_down'.tr,
                        onStart: (VoidCallback callback) {
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
      ),
    );
  }
}
