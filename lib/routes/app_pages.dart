import 'package:filmsystem/pages/detail.dart';
import 'package:filmsystem/pages/download.dart';
import 'package:filmsystem/pages/favorite.dart';
import 'package:filmsystem/pages/forget.dart';
import 'package:filmsystem/pages/help.dart';
import 'package:filmsystem/pages/home.dart';
import 'package:filmsystem/pages/login.dart';
import 'package:filmsystem/pages/news.dart';
import 'package:filmsystem/pages/search.dart';
import 'package:filmsystem/pages/subject.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/pages/webiew.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          preventDuplicates: true,
          name: _Paths.login,
          page: () => const LoginPage(),
          // transition: Transition.cupertino,
        ),
        // GetPage(
        //   preventDuplicates: true,
        //   name: _Paths.home,
        //   page: () => const HomePage(),
        //   title: null,
        // ),
        GetPage(
          name: _Paths.favorite,
          page: () => const FavoritePage(),
        ),
        GetPage(
          name: _Paths.news,
          page: () => const NewsPage()
        ),
        GetPage(
            name: _Paths.video,
            page: () => const VideoPage()
        ),
        GetPage(
            name: _Paths.forget,
            page: () => const ForgetPage()
        ),
        GetPage(
            name: _Paths.search,
            page: () => const SearchPage()
        ),
        GetPage(
            name: _Paths.subject,
            page: () => const SubjectPage()
        ),
        GetPage(
            name: _Paths.detail,
            page: () => const DetailPage()
        ),
        GetPage(
            name: _Paths.help,
            page: () => const HelpPage()
        ),
        GetPage(
            name: _Paths.webView,
            page: () =>  WebViewScreen()
        ),
        GetPage(
            name: _Paths.download,
            page: () =>  const DownloadPage()
        ),
      ],
    ),
  ];
}
