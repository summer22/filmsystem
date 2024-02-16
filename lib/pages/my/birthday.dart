import 'package:filmsystem/pages/widgets/simple_cupertino_date_picker.dart';
import 'package:filmsystem/utils/simple_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {

  DateTime _selectedDate = DateTime(1999, 1, 1);

  @override
  void initState() {
    super.initState();
    if((SimpleStorage.readUserInfo().Birthday?.length ?? 0) > 0){
      List<int> dates = SimpleStorage.readUserInfo().Birthday!.split("-").map((e) => int.parse(e)).toList();
      _selectedDate =  DateTime(dates.first, dates[1], dates.last);
    }
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

              }),
        ],
        title: Text(
          'birthday'.tr,
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
                  _showDatePickerDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'birthday'.tr,
                      style:
                      const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
                    ),
                    Text(
                      "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
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
