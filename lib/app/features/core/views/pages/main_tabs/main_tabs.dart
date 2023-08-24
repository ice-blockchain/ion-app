import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/controllers/main_tabs_controller.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/widgets/tab_bar.dart';
import 'package:ice/app/features/core/views/pages/main_tabs_routes.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';

class MainTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainTabsController());
  }
}

Route<Object>? onGenerateRoute(RouteSettings settings) {
  return switch (settings.name) {
    MainTabsPaths.home => GetPageRoute<Object>(
        settings: settings,
        page: () => const Placeholder(
          color: Colors.green,
        ),
        transition: Transition.noTransition,
        // binding: BrowseBinding(),
      ),
    MainTabsPaths.messages => GetPageRoute<Object>(
        settings: settings,
        page: () => const Placeholder(
          color: Colors.blueAccent,
        ),
        transition: Transition.noTransition,
        // binding: HistoryBinding(),
      ),
    MainTabsPaths.wallet => GetPageRoute<Object>(
        settings: settings,
        page: () => WalletPage(),
        transition: Transition.noTransition,
        // binding: SettingsBinding(),
      ),
    MainTabsPaths.deFi => GetPageRoute<Object>(
        settings: settings,
        page: () => const Placeholder(
          color: Colors.red,
        ),
        transition: Transition.noTransition,
        // binding: SettingsBinding(),
      ),
    _ => null
  };
}

class MainTabs extends StatelessWidget {
  const MainTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView
      body: Navigator(
        key: Get.nestedKey(MainTabsController.navigatorId),
        initialRoute: MainTabsController.initialRoute,
        onGenerateRoute: onGenerateRoute,
      ),
      bottomNavigationBar: const MainTabsBar(),
    );
  }
}
