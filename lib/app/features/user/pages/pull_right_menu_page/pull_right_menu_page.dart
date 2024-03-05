import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/footer/footer.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/header/header.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/links_list/links_list.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/profile_info/profile_info.dart';
import 'package:ice/app/router/app_routes.dart';

class PullRightMenuPage extends IceSimplePage {
  const PullRightMenuPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => IceRoutes.feed.go(context),
      child: Material(
        color: context.theme.appColors.secondaryBackground,
        child: const Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
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
