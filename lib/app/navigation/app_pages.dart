import 'package:get/get.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/core/views/pages/main_tabs.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';

part './app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<Object>(name: Routes.splash, page: () => const SplashPage()),
    GetPage<Object>(
      name: Routes.auth,
      page: () => AuthPage(),
      transition: Transition.fade,
    ),
    GetPage<Object>(
      name: Routes.main,
      page: () => const MainTabs(),
      binding: MainTabsBinding(),
      transition: Transition.fade,
    ),
  ];
}
