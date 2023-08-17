part of './app_pages.dart';

abstract class Routes {
  Routes._();

  static const String splash = _Paths.splash;
  static const String auth = _Paths.auth;
  static const String main = _Paths.main;
  static const String wallet = _Paths.wallet;
}

abstract class _Paths {
  _Paths._();

  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String main = '/main';
  static const String wallet = '/wallet';
}
