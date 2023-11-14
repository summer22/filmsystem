import 'package:filmsystem/pages/home.dart';
import 'package:filmsystem/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_theme.dart';

/// @ClassName LaunchPage
/// @Description 启动入口页面
/// @Author summer
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      Get.offAll(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          launchAssets,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
