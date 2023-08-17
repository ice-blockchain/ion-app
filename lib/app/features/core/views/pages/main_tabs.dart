import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';

class MainTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainTabsController());
  }
}

class MainTabsController extends GetxController {
  static MainTabsController get to => Get.find(); //??

  RxInt currentIndex = 0.obs;

  final List<String> pages = <String>['/browse', '/history', '/settings'];

  void changePage(int index) {
    currentIndex.value = index;
    Get.offAndToNamed(pages[index], id: 1);
  }

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      '/browse' => GetPageRoute<Object>(
          settings: settings,
          page: () => WalletPage(),
          transition: Transition.noTransition,
          // binding: BrowseBinding(),
        ),
      '/history' => GetPageRoute<Object>(
          settings: settings,
          page: () => WalletPage(),
          transition: Transition.noTransition,
          // binding: HistoryBinding(),
        ),
      '/settings' => GetPageRoute<Object>(
          settings: settings,
          page: () => WalletPage(),
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
        key: Get.nestedKey(1),
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
