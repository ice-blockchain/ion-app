import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/controllers/main_tabs_controller.dart';
import 'package:ice/icons/icomoon_icons.dart';
import 'package:ice/utils/number_utils.dart';

class MainTabsBarMainTileIcon extends GetView<MainTabsController> {
  const MainTabsBarMainTileIcon({super.key});

  static final double iconSize = 30.w;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final IconData iconData = controller.bottomSheetVisible.isTrue
            ? IcoMoonIcons.close
            : IcoMoonIcons.iceLogo;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Transform.rotate(
            key: ValueKey<IconData>(iconData),
            angle: toRadians(45),
            child: Icon(
              iconData,
              size: iconSize,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}
