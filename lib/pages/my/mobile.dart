import 'package:filmsystem/pages/widgets/custom_cupertino_picker.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/functions.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  final TextEditingController _mobileController = TextEditingController();
  bool _showMobileClearButton = false;
  String selectedCode = "+86";

  @override
  void initState() {
    super.initState();
    if((SimpleStorage.readUserInfo().callingCode?.length ?? 0) > 0){
      selectedCode = "+${SimpleStorage.readUserInfo().callingCode}";
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
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
                  if(!isValidPhoneNumber(_mobileController.text)){
                    EasyLoading.showToast('mobile_toast'.tr);
                    return;
                  }
                }),
          ],
          title: Text(
            'phone_number'.tr,
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
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          selectedCode,
                          style: const TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 14),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF3D3D3D),
                          size: 40,
                        )
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomCupertinoPicker(
                            onSelected: (String number) {
                              setState(() {
                                selectedCode = number;
                              });
                            },
                            contentList: countryCodeList,
                          );
                        },
                      );
                    },
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
                          keyboardType: TextInputType.phone,
                          cursorColor: const Color(0xFFA1A1A1),
                          controller: _mobileController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            hintText: 'mobile_hint'.tr,
                            hintStyle: const TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                            suffixIcon: _showMobileClearButton
                                ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFFA1A1A1),
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
