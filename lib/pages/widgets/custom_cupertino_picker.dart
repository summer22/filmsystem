import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCupertinoPicker extends StatefulWidget {

  const CustomCupertinoPicker({
    Key? key,
    required this.onSelected,
    required this.contentList,
  }) : super(key: key);

  ///选择回调
  final Function(String) onSelected;
  ///数据列表
  final List<String> contentList;

  @override
  _CustomCupertinoPickerState createState() =>
      _CustomCupertinoPickerState();

}

class _CustomCupertinoPickerState
    extends State<CustomCupertinoPicker> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('cancel'.tr, style: const TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: Text('sure'.tr, style: const TextStyle(color: Colors.black),),
                  onPressed: () {
                    widget.onSelected(widget.contentList[selectedValue]);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedValue = index;
                });
              },
              children: widget.contentList.map((e) =>  Center(
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 20),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}