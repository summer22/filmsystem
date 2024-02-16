import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleCupertinoDatePicker extends StatelessWidget {

   SimpleCupertinoDatePicker({super.key, required this.onSelected, required this.initialDateTime});

  final Function(DateTime) onSelected;

  final DateTime initialDateTime;

  DateTime _changeDate = DateTime(1999, 1, 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel'.tr, style: const TextStyle(color: Colors.black)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        onSelected(_changeDate);
                        Navigator.pop(context);
                      },
                      child: Text('sure'.tr,style: const TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDateTime) {
                      _changeDate = newDateTime;
                    },
                    initialDateTime: initialDateTime,
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime(1900, 1, 1),
                    dateOrder: DatePickerDateOrder.ymd,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
