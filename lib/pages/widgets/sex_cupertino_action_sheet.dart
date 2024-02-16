import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SexCupertinoActionSheet extends StatelessWidget {

  const SexCupertinoActionSheet({super.key, required this.onSelected});

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            onSelected('sex_male'.tr);
            Navigator.pop(context);
          },
          child: Text('sex_male'.tr, style: const TextStyle(color: Colors.black)),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            onSelected('sex_female'.tr);
            Navigator.pop(context);
          },
          child: Text('sex_female'.tr, style: const TextStyle(color: Colors.black)),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            onSelected('sex_secrecy'.tr);
            Navigator.pop(context);
          },
          child: Text('sex_secrecy'.tr, style: const TextStyle(color: Colors.black)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('cancel'.tr, style: const TextStyle(color: Colors.black),),
      ),
    );
  }

}
