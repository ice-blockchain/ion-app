import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/accounts_list/accounts_list.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/actions_list/actions_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class SwitchAccountPage extends IcePage {
  const SwitchAccountPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationAppBar.modal(
              showBackButton: false,
              title: context.i18n.profile_switch_user_header,
              actions: const <Widget>[
                NavigationCloseButton(),
              ],
            ),
            ScreenSideOffset.small(child: const AccountsList()),
            ScreenSideOffset.small(child: const ActionsList()),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
