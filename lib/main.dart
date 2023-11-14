import 'dart:io';

import 'package:filmsystem/app/routes/app_pages.dart';
import 'package:filmsystem/lang/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();

  runApp(GetMaterialApp(
    title: "filmsystem",
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    translations: Messages(),
    localizationsDelegates: const [
      RefreshLocalizations.delegate,
    ],
    locale: const Locale('zh', 'CN'), //设置默认语言
    fallbackLocale: const Locale("zh", "CN"), // 在配置错误的情况下,使用的语言
    getPages: AppPages.routes,
    initialRoute: AppPages.initial,
    builder: EasyLoading.init(),

  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
