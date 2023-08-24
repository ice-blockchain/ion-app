import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/controllers/main_tabs_controller.dart';
import 'package:ice/app/features/core/views/pages/main_tabs_routes.dart';
import 'package:ice/icons/icomoon_icons.dart';

IconData? toIconData(String tabName) {
  switch (tabName) {
    case MainTabsPaths.home:
      {
        return IcoMoonIcons.home;
      }
    case MainTabsPaths.messages:
      {
        return IcoMoonIcons.messages;
      }
    case MainTabsPaths.wallet:
      {
        return IcoMoonIcons.wallet;
      }
    case MainTabsPaths.de_fi:
      {
        return IcoMoonIcons.de_fi;
      }
  }
  return null;
}

class MainTabsBarTile extends GetView<MainTabsController> {
  const MainTabsBarTile({super.key, required this.tabName});

  final String tabName;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(
          toIconData(tabName),
          size: 24.w,
        ),
        onPressed: () => controller.changeTab(tabName),
        color: controller.currentTabName.value == tabName
            ? Theme.of(context).primaryColor
            : Theme.of(context).hintColor,
      ),
    );
  }
}
