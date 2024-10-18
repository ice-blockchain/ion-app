// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/footer/footer.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/links_list/links_list.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/profile_details/profile_details.dart';

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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Positioned(child: BackgroundPicture()),
            SingleChildScrollView(
              child: ScreenTopOffset(
                child: Column(
                  children: [
                    SizedBox(height: 115.0.s),
                    const ProfileDetails(),
                    SizedBox(height: 20.0.s),
                    const LinksList(),
                    const Footer(),
                  ],
                ),
              ),
            ),
            const Positioned(child: Header()),
          ],
        ),
      ),
    );
  }
}
