import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/controllers/main_tabs_controller.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/widgets/tab_bar_main_tile.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/widgets/tab_bar_tile.dart';
import 'package:ice/app/features/core/views/pages/main_tabs_routes.dart';

class MainTabsBar extends GetView<MainTabsController> {
  const MainTabsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MainTabsBarTile(tabName: MainTabsPaths.home),
              MainTabsBarTile(tabName: MainTabsPaths.messages),
              MainTabsBarMainTile(),
              MainTabsBarTile(tabName: MainTabsPaths.wallet),
              MainTabsBarTile(tabName: MainTabsPaths.deFi),
            ],
          ),
        ),
      ),
    );
  }
}
