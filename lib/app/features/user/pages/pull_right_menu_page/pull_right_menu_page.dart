import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/footer/footer.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/header/header.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/links_list/links_list.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/profile_info/profile_info.dart';
import 'package:go_router/go_router.dart';

class PullRightMenuPage extends StatelessWidget {
  const PullRightMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.appColors.secondaryBackground,
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dx < -100) {
            context.pop();
          }
        },
        child: const Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ProfileInfo(),
                  LinksList(),
                  Footer(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Header(),
            ),
          ],
        ),
      ),
    );
  }
}
