import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/code_model.dart';
import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/data/models/login/login_model.dart';
import 'package:filmsystem/data/models/sign_in/hobby_list_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/home.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:filmsystem/pages/widgets/buttons/count_down_button.dart';
import 'package:filmsystem/pages/widgets/custom_cupertino_picker.dart';
import 'package:filmsystem/pages/widgets/sex_cupertino_action_sheet.dart';
import 'package:filmsystem/pages/widgets/simple_cupertino_date_picker.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/functions.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _repwdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();

  bool _showPwdClearButton = false;
  bool _showRepwdClearButton = false;
  bool _showMobileClearButton = false;
  bool _repwdCipherText = true;
  bool _showCodeClearButton = false;
  bool _showEmailClearButton = false;
  bool _showNameClearButton = false;

  bool _cipherText = true;
  String smsToken = "";
  String selectedCode = "+86";
  String callingCode = "";
  String selectedSex = 'sex_secrecy'.tr;
  DateTime _selectedDate = DateTime(1999, 1, 1);

  HobbyListModel? hobbyListModel;
  List<HobbyModel> selectedHobbyModel = [];
  double girdH = 0;

  @override
  void initState() {
    super.initState();
    getHobbyData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _repwdController.dispose();
    _mobileController.dispose();
    _codeController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  void getHobbyData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.hobby;
    request.isShowLoading = false;
    try {
      ApiResponse response = await Api().fire(request);
      setState(() {
        hobbyListModel = HobbyListModel.fromJson(response.data);
        double h = (Get.width - 88 - 10) / 3 / 0.9;
        int rowCount = ((hobbyListModel?.data?.length ?? 0) / 3).ceil();
        girdH = (h + 10) * rowCount;
      });
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
    request.add("nickname", _nickNameController.text);
    request.add("password", _pwdController.text);
    request.add("mobile", _mobileController.text);
    request.add("callingCode", callingCode.isNotEmpty ? callingCode.split("+").last : "");
    request.add(
        "like", selectedHobbyModel.map((e) => e.headNo).toList());
    request.add("email", _emailController.text);
    request.add("smsCode", _codeController.text);
    request.add("token", smsToken);
    request.add("gender", genderList.indexOf(selectedSex));
    request.add("bithday", "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}");

    try {
      await Api().fire(request);
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
    request.add("password", _pwdController.text);
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
      Get.offAll(const HomePage());
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

  ///返回logo
  _topWidget() {
    return Builder(
      builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 25, top: 50),
          child: GestureDetector(
              child: Image.asset(logoAssets,
                  height: 30,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft),
              onTap: () => Get.back())),
    );
  }

  ///性别选择
  void _showGenderActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SexCupertinoActionSheet(onSelected: (selected){
          setState(() {
            selectedSex = selected;
          });
        },);
      },
    );
  }

  ///时间选择器
  void _showDatePickerDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SimpleCupertinoDatePicker(onSelected: (selected){
          setState(() {
            _selectedDate = selected;
          });
        }, initialDateTime: _selectedDate,);
        },
    );
  }

  Widget _contentWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 25, left: 22, right: 22),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          // borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
          color: Colors.black87,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 32, 22, 0),
              child: Text(
                'sign_up'.tr,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(inputMarkAssets,
                        width: 15,
                        height: 10,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    Expanded(
                        child: TextField(
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
                    )),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(inputMarkAssets,
                        width: 15,
                        height: 10,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    Expanded(
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
                    )),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(inputMarkAssets,
                        width: 15,
                        height: 10,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    Expanded(
                        child: TextField(
                      obscureText: _repwdCipherText,
                      cursorColor: Colors.black,
                      controller: _repwdController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        hintText: 'pwd_again'.tr,
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
                        suffixIcon: _repwdRightIcon(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _showRepwdClearButton = value.isNotEmpty;
                        });
                      },
                    )),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(inputMarkAssets,
                        width: 15,
                        height: 10,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextField(
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            controller: _codeController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              hintText: 'code'.tr,
                              hintStyle: const TextStyle(color: Colors.black45),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
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
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(inputMarkAssets,
                        width: 15,
                        height: 10,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    Expanded(
                        child: TextField(
                      cursorColor: Colors.black,
                      controller: _nickNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        hintText: 'nick_name'.tr,
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
                        suffixIcon: _showNameClearButton
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _nickNameController.clear();
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
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 22, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 80,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                  selectedCode,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 14),
                                )),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomCupertinoPicker(
                              onSelected: (String number) {
                                setState(() {
                                  selectedCode = number;
                                  callingCode = number;
                                });
                              },
                              contentList: countryCodeList,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.black,
                          controller: _mobileController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            hintText: 'mobile_hint'.tr,
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
                            suffixIcon: _showMobileClearButton
                                ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                                size: 20,
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
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 28, 22, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      'sex'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.black,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            selectedSex,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          )),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                            size: 40,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _showGenderActionSheet(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 22, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      'birthday'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: Text(
                        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    onTap: () {
                      _showDatePickerDialog(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(inputMarkAssets,
                          width: 15,
                          height: 10,
                          fit: BoxFit.contain,
                          alignment: Alignment.topLeft),
                    ),
                    Expanded(
                        child: Text('movie_hobby_desc'.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFFA1A1A1), fontSize: 14),
                    )),
                  ],
                )),
          ],
        ));
  }

  ///选择影片
  Widget _grid() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 3),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.9),
      itemCount: hobbyListModel?.data?.length ?? 0, // 你的数据项总数
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              HobbyModel? model = hobbyListModel?.data?[index];
              if (selectedHobbyModel.contains(model)) {
                selectedHobbyModel.remove(model);
              } else {
                selectedHobbyModel.add(model!);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: selectedHobbyModel.contains(hobbyListModel?.data?[index])
                  ? Border.all(color: const Color(0xFF27D7F6), width: 2.0)
                  : null,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CachedNetworkImage(
              key: ValueKey(hobbyListModel?.data?[index]?.posterUrl ?? ""),
              fit: BoxFit.fitHeight,
              placeholder: (context, url) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SizedBox(),
                );
              },
              imageUrl: hobbyListModel?.data?[index]?.posterUrl ?? "",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return Container(
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
    );
  }

  ///底部按钮
  Widget _bottomBtn() {
    return  Container(
        margin: const EdgeInsets.only(left: 22, right: 22),
        padding: const EdgeInsets.only(left: 22, right: 22),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          color: Colors.black87,
        ),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width - 44,
              height: 44,
              child: Button(
                text: 'sign_in_btn_title'.tr,
                textColor: Colors.black,
                backgroundColor: const Color(0xFF27D7F6),
                radius: 8,
                textStyle: const TextStyle(fontSize: 14),
                click: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(_emailController.text.isEmpty){
                    EasyLoading.showToast('name_hint'.tr,
                        toastPosition: EasyLoadingToastPosition.bottom);
                    return;
                  }
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
                  if (!isNicknameValid(_nickNameController.text)) {
                    EasyLoading.showToast('nickname_hint'.tr);
                    return;
                  }
                  if (_mobileController.text.isNotEmpty) {
                    if(!isValidPhoneNumber(_mobileController.text)){
                      EasyLoading.showToast('mobile_toast'.tr);
                      return;
                    }
                  }
                  if (selectedHobbyModel.length < 3) {
                    EasyLoading.showToast('nickname_hint'.tr);
                    return;
                  }
                  getData();
                },
              ),
            ),
          ],
        ));
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topWidget(),
                  _contentWidget(),
                  Container(
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      padding: const EdgeInsets.only(left: 22, right: 22),
                      decoration: const BoxDecoration(color: Colors.black87),
                      height: girdH,
                      child: _grid()),
                  _bottomBtn(),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
