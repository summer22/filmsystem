import 'package:filmsystem/utils/functions.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NickNamePage extends StatefulWidget {
  const NickNamePage({super.key});

  @override
  State<NickNamePage> createState() => _NickNamePageState();
}

class _NickNamePageState extends State<NickNamePage> {
  final TextEditingController _nickNameController = TextEditingController();
  bool _showNameClearButton = false;

  @override
  void initState() {
    super.initState();
    _nickNameController.text = SimpleStorage.readUserInfo().nickname ?? "";
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    super.dispose();
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
                  if (!isNicknameValid(_nickNameController.text)) {
                    EasyLoading.showToast('nickname_hint'.tr);
                    return;
                  }
                }),
          ],
          title: Text(
            'nick_name_title'.tr,
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
                  Text(
                    'nick_name_title'.tr,
                    style:
                        const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                      child: SizedBox(
                    height: 45,
                    child: TextField(
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA1A1A1),
                      ),
                      textAlign: TextAlign.right,
                      cursorColor: const Color(0xFFA1A1A1),
                      controller: _nickNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                        hintText: 'nick_name'.tr,
                        hintStyle: const TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        suffixIcon: _showNameClearButton
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFFA1A1A1),
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
                    ),
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
