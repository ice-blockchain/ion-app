import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_selectors.dart';

class WalletSwitcher extends HookConsumerWidget {
  const WalletSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String walletName = walletNameSelector(ref);
    final String walletIcon = walletIconSelector(ref);
    return Button.dropdown(
      onPressed: () {},
      leadingIcon: Avatar(
        size: 28.0.s,
        imageUrl: walletIcon,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      leadingButtonOffset: 11.0.s,
      trailingIconOffset: 0.0.s,
      backgroundColor: context.theme.appColors.tertararyBackground,
      label: Text(
        walletName,
        style: context.theme.appTextThemes.subtitle2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
