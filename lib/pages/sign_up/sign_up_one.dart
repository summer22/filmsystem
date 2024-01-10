import 'package:filmsystem/pages/sign_up/sign_up_controller.dart';
import 'package:filmsystem/pages/sign_up/sign_up_two.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpOne extends StatefulWidget {
  const SignUpOne({super.key});

  @override
  State<SignUpOne> createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _repwdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _showNameClearButton = false;
  bool _showPwdClearButton = false;
  bool _showRepwdClearButton = false;
  bool _showMobileClearButton = false;
  bool _cipherText = true;
  bool _repwdCipherText = true;

  late SignUpController _controller; // 控制器实例

  @override
  void initState() {
    _controller = Get.find<SignUpController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _pwdController.dispose();
    _repwdController.dispose();
    _mobileController.dispose();
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
                _repwdCipherText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '第1步(共4步)',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '我们依照每个的喜好和语言偏好为您精心推荐影片，您家中的每个成员都能拥有自己的专属片单，还有儿童专区',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16),
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
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '真实姓名',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            hintText: '真实姓名',
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
                            suffixIcon: _showNameClearButton
                                ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _nameController.clear();
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
                        '密码',
                        textAlign: TextAlign.end,
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
                            hintText: '请输入您的密码',
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
                            suffixIcon: _rightIcon(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showPwdClearButton= value.isNotEmpty;
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
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '确认密码',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                          obscureText: _repwdCipherText,
                          cursorColor: Colors.black,
                          controller: _repwdController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            hintText: '请再次输入您的密码',
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
                            suffixIcon: _repwdRightIcon(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showRepwdClearButton = value.isNotEmpty;
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
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '电话号码',
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
                            hintText: '请输入有效的电话号码',
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
                          onChanged: (value) {
                            setState(() {
                              _showMobileClearButton = value.isNotEmpty;
                            });
                          },
                        )),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: Get.width - 40,
                  height: 50,
                  child: Button(
                    text: '下一步',
                    textColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 18),
                    click: () {
                      if(_nameController.text.isEmpty){
                        EasyLoading.showToast('请输入名字',
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_pwdController.text.isEmpty || _pwdController.text.length < 4 || _pwdController.text.length > 20){
                        EasyLoading.showToast('您的密码必须包含4到20个字符',
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_repwdController.text.isEmpty || _pwdController.text.length < 4 || _pwdController.text.length > 20){
                        EasyLoading.showToast('您的密码必须包含4到20个字符',
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_pwdController.text != _repwdController.text){
                        EasyLoading.showToast('两次输入密码不一致',
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }
                      if(_mobileController.text.isEmpty){
                        EasyLoading.showToast('请输入有效的电话号码',
                            toastPosition: EasyLoadingToastPosition.bottom);
                        return;
                      }

                      _controller.name = _nameController.text;
                      _controller.pwd = _pwdController.text;
                      _controller.rePwd = _repwdController.text;
                      _controller.mobile = _mobileController.text;

                      Get.to(() => const SignUpTwo());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
