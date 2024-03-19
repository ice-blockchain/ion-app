import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/providers/user_preferences_provider.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/constants.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletTabsHeaderHideAction extends HookConsumerWidget {
  const WalletTabsHeaderHideAction({
    super.key,
  });

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);
    final Color actionColor = context.theme.appColors.tertararyText;
    final AssetGenImage asset = isZeroValueAssetsVisible
        ? Assets.images.icons.iconCheckboxOff
        : Assets.images.icons.iconBlockCheckboxOnblue;
    return TextButton(
      onPressed: () {
        ref
            .watch(userPreferencesNotifierProvider.notifier)
            .switchZeroValueAssetsVisibility();
      },
      child: Padding(
        padding: EdgeInsets.all(Constants.hitSlop),
        child: Row(
          children: <Widget>[
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
              style: context.theme.appTextThemes.caption
                  .copyWith(color: actionColor),
            ),
          ],
        ),
      ),
    );
  }
}
