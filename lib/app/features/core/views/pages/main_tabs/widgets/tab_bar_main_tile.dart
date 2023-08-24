import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/controllers/main_tabs_controller.dart';
import 'package:ice/app/features/core/views/pages/main_tabs/widgets/tab_bar_main_tile_icon.dart';
import 'package:ice/utils/number_utils.dart';

class MainTabsBarMainTile extends GetView<MainTabsController> {
  const MainTabsBarMainTile({super.key});

  static final double containerSize = 44.w;
  static final double radius = 15.w;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.switchBottomSheetVisible,
      child: Transform.rotate(
        angle: toRadians(45),
        child: Container(
          height: containerSize,
          width: containerSize,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(
              radius,
            ),
          ),
          child: const Center(
            child: MainTabsBarMainTileIcon(),
          ),
        ),
      ),
    );
  }
}
