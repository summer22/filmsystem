part of 'app_pages.dart';

abstract class Routes {

  static const test = _Paths.test;
  static const launch = _Paths.launch;
  static const home = _Paths.home;
  static const favorite = _Paths.favorite;
  static const news = _Paths.news;
  static const login = _Paths.login;
  static const forget = _Paths.forget;
  static const search = _Paths.search;
  static const subject = _Paths.subject;
  static const detail = _Paths.detail;
  static const video = _Paths.video;
  static const help = _Paths.help;
  static const webView = _Paths.webView;
  static const download = _Paths.download;

  Routes._();

}

abstract class _Paths {

  static const test = '/test';
  static const launch = '/launch';
  static const home = '/home';
  static const favorite = '/favorite';
  static const news = '/news';
  static const login = '/login';
  static const forget = '/forget';
  static const search = '/search';
  static const subject = '/subject';
  static const detail = '/detail';
  static const video = '/video';
  static const help = '/help';
  static const webView = '/webView';
  static const download = '/download';

}
