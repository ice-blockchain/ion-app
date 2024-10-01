// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/pages/restore_menu/restore_menu_item.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RestoreMenuPage extends HookWidget {
  const RestoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.restore_identity_title,
        description: context.i18n.restore_identity_type_description,
        icon: Assets.svg.iconLoginRestorekey.icon(size: 36.0.s),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0.s),
            child: Column(
              children: [
                SizedBox(height: 12.0.s),
                RestoreMenuItem(
                  icon: Assets.svg.walletLoginCloud.icon(size: 48.0.s),
                  title: context.i18n.restore_identity_type_icloud_title,
                  description: context.i18n.restore_identity_type_icloud_description,
                  onPressed: () {},
                ),
                SizedBox(height: 16.0.s),
                RestoreMenuItem(
                  icon: Assets.svg.walletLoginRecovery.icon(size: 48.0.s),
                  title: context.i18n.restore_identity_type_credentials_title,
                  description: context.i18n.restore_identity_type_credentials_description,
                  onPressed: () {
                    hideKeyboardAndCallOnce(
                      callback: () => RestoreRecoveryKeysRoute().push<void>(context),
                    );
                  },
                ),
                SizedBox(height: 12.0.s),
              ],
            ),
          ),
          ScreenBottomOffset(
            child: const AuthFooter(),
          ),
        ],
      ),
    );
  }
}
