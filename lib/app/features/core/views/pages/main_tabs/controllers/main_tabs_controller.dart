import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs_routes.dart';

class MainTabsController extends GetxController {
  static const String initialRoute = MainTabsPaths.home;
  static const int navigatorId = 1;

  RxString currentTabName = RxString(MainTabsController.initialRoute);
  RxBool bottomSheetVisible = RxBool(false);

  void changeTab(String tabName) {
    currentTabName.value = tabName;
    Get.toNamed(tabName, id: MainTabsController.navigatorId);
  }

  void switchBottomSheetVisible() {
    bottomSheetVisible.value = !bottomSheetVisible.value;
  }
}
