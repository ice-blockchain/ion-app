import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/accounts_list/accounts_list.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/actions_list/actions_list.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/header/header.dart';

class SwitchAccountPage extends IceSimplePage {
  const SwitchAccountPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      body: ScreenSideOffset.small(
        child: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Header(),
              AccountsList(),
              ActionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
