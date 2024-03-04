import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_provider.dart';

class WalletSwitcher extends HookConsumerWidget {
  const WalletSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WalletData walletData = ref.watch(walletDataNotifierProvider);
    return Button.dropdown(
      onPressed: () {},
      leadingIcon: Avatar(
        size: 24.0.s,
        imageUrl: walletData.icon,
      ),
      leadingButtonOffset: 8.0.s,
      backgroundColor: context.theme.appColors.tertararyBackground,
      label: Text(
        walletData.name,
        style: TextStyle(color: context.theme.appColors.primaryText),
      ),
    );
  }
}
