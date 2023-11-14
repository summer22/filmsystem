part of 'app_pages.dart';

abstract class Routes {

  static const home = _Paths.home;
  static const favorite = _Paths.favorite;
  static const news = _Paths.news;
  static const login = _Paths.login;
  static const launch = _Paths.launch;
  static const search = _Paths.search;
  static const subject = _Paths.subject;
  static const detail = _Paths.detail;
  static const video = _Paths.video;
  static const test = _Paths.test;

  Routes._();
}

abstract class _Paths {

  static const launch = '/launch';
  static const home = '/home';
  static const favorite = '/favorite';
  static const news = '/news';
  static const login = '/login';
  static const search = '/search';
  static const subject = '/subject';
  static const detail = '/detail';
  static const video = '/video';
  static const test = '/test';

}
