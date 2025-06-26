// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RecoveryKeysSuccessPage extends ConsumerWidget {
  const RecoveryKeysSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 27.0.s,
          ),
          ScreenSideOffset.medium(
            child: InfoCard(
              iconAsset: Assets.svg.actionWalletSecureaccsuccess,
              title: locale.recovery_keys_successfully_protected_title,
              description: locale.recovery_keys_successfully_protected_description,
            ),
          ),
          SizedBox(
            height: 28.0.s,
          ),
          ScreenSideOffset.large(
            child: Button(
              onPressed: () => SecureAccountOptionsRoute().replace(context),
              label: Text(locale.button_back_to_security),
              mainAxisSize: MainAxisSize.max,
            ),
          ),
          ScreenBottomOffset(margin: 28.0.s),
        ],
      ),
    );
  }
}
