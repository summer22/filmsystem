import 'dart:io';

import 'package:filmsystem/routes/app_pages.dart';
import 'package:filmsystem/lang/messages.dart';
import 'package:filmsystem/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart';
// import 'package:shelf/src/response.dart' as ShelfResponse;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await Storage.init();

  // final overrideHeaders = {
  //   ACCESS_CONTROL_ALLOW_ORIGIN: 'https://192.168.2.200',
  //   'Content-Type': 'application/json;charset=utf-8'
  // };
  //
  // var handler = const Pipeline()
  //     .addMiddleware(corsHeaders(headers: overrideHeaders))
  //     .addHandler(_echoRequest);
  //
  // var server = await serve(handler, 'localhost', 8080);
  //
  // // Enable content compression
  // server.autoCompress = true;
  // print('Serving at http://${server.address.host}:${server.port}');

  runApp(GetMaterialApp(
    title: "filmsystem",
    darkTheme: ThemeData(
      primaryColor: Colors.black87,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    // themeMode: ThemeMode.dark,
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

// ShelfResponse.Response _echoRequest(Request request) {
//   return ShelfResponse.Response.ok('Request for "${request.url}"');
// }

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
