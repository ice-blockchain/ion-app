import 'package:get/get.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/main_tabs.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/navigation/middlewares/auth_guard_middleware.dart';

part './app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<Object>(name: Routes.splash, page: () => SplashPage()),
    GetPage<Object>(
      name: Routes.auth,
      page: () => AuthPage(),
      transition: Transition.noTransition,
    ),
    GetPage<Object>(
      name: Routes.main,
      page: () => const MainTabs(),
      middlewares: <GetMiddleware>[AuthGuardMiddleware()],
      binding: MainTabsBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
