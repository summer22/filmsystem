import 'package:filmsystem/pages/favorite.dart';
import 'package:filmsystem/pages/home.dart';
import 'package:filmsystem/pages/launch.dart';
import 'package:filmsystem/pages/login.dart';
import 'package:filmsystem/pages/news.dart';
import 'package:filmsystem/pages/video.dart';
import 'package:filmsystem/pages/widgets/slide_pop_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,//'/',
      page: () => const HomePage(),//LaunchPage(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          preventDuplicates: true,
          name: _Paths.login,
          page: () => const LoginPage(),
          // transition: Transition.cupertino,
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.home,
          page: () => const HomePage(),
          title: null,
        ),
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
            name: _Paths.test,
            page: () =>  MyHomePage()
        ),

      ],
    ),
  ];
}
