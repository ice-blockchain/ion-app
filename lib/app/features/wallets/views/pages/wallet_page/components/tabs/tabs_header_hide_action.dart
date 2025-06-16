// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/wallet_user_preferences_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletTabsHeaderHideAction extends ConsumerWidget {
  const WalletTabsHeaderHideAction({
    super.key,
  });

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);
    final actionColor = context.theme.appColors.tertararyText;
    final asset =
        isZeroValueAssetsVisible ? Assets.svgIconCheckboxOff : Assets.svgIconBlockCheckboxOnblue;

    return TextButton(
      onPressed: () {
        final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
        ref
            .read(walletUserPreferencesNotifierProvider(identityKeyName: identityKeyName).notifier)
            .switchZeroValueAssetsVisibility();
      },
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Row(
          children: [
            if (isZeroValueAssetsVisible)
              asset.icon(
                color: actionColor,
                size: iconSize,
              )
            else
              asset.icon(
                size: iconSize,
              ),
            SizedBox(
              width: 6.0.s,
            ),
            Text(
              context.i18n.wallet_hide,
              style: context.theme.appTextThemes.caption.copyWith(color: actionColor),
            ),
          ],
        ),
      ),
    );
  }
}
