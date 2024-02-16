import 'package:filmsystem/pages/widgets/sex_cupertino_action_sheet.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SexPage extends StatefulWidget {
  const SexPage({super.key});

  @override
  State<SexPage> createState() => _SexPageState();
}

class _SexPageState extends State<SexPage> {

  String selectedSex = 'sex_secrecy'.tr;

  @override
  void initState() {
    super.initState();
    selectedSex = genderList[SimpleStorage.readUserInfo().gender ?? 0];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child:  Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  'save'.tr,
                  style: const TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontSize: 14),
                ),
              ),
              onTap: () {

              }),
        ],
        title: Text(
          'sex'.tr,
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(color: Colors.white),
            child: GestureDetector(
              onTap: (){
                _showGenderActionSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sex'.tr,
                    style:
                    const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                  ),
                  Text(
                    selectedSex,
                    textAlign: TextAlign.start,
                    style:
                    const TextStyle(color: Color(0xFFA1A1A1), fontSize: 14),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
