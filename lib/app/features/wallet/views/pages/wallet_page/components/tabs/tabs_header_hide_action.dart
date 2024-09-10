import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';
import 'package:ice/generated/assets.gen.dart';

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
        isZeroValueAssetsVisible ? Assets.svg.iconCheckboxOff : Assets.svg.iconBlockCheckboxOnblue;

    return TextButton(
      onPressed: () {
        final userId = ref.read(currentUserIdSelectorProvider);
        ref
            .read(walletUserPreferencesNotifierProvider(userId: userId).notifier)
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
