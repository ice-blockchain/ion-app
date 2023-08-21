import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs_routes.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';

const int mainTabsNavigatorId = 1;

class MainTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainTabsController());
  }
}

class MainTabsController extends GetxController {
  static MainTabsController get to => Get.find(); //??

  RxInt currentIndex = 0.obs;

  final List<String> pages = <String>[
    MainTabsPaths.browse,
    MainTabsPaths.history,
    MainTabsPaths.settings
  ];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: mainTabsNavigatorId);
  }

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      MainTabsPaths.browse => GetPageRoute<Object>(
          settings: settings,
          page: () => WalletPage(),
          transition: Transition.noTransition,
          // binding: BrowseBinding(),
        ),
      MainTabsPaths.history => GetPageRoute<Object>(
          settings: settings,
          page: () => const Placeholder(
            color: Colors.blueAccent,
          ),
          transition: Transition.noTransition,
          // binding: HistoryBinding(),
        ),
      MainTabsPaths.settings => GetPageRoute<Object>(
          settings: settings,
          page: () => const Placeholder(
            color: Colors.amber,
          ),
          transition: Transition.noTransition,
          // binding: SettingsBinding(),
        ),
      _ => null
    };
  }
}

class MainTabs extends GetView<MainTabsController> {
  const MainTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView
      body: Navigator(
        key: Get.nestedKey(mainTabsNavigatorId),
        initialRoute: '/browse',
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: controller.currentIndex.value,
          selectedItemColor: Colors.pink,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
