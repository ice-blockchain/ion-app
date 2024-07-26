import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/app_routes.dart';

class WalletSwitcher extends ConsumerWidget {
  const WalletSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(currentWalletDataProvider);

    return Button.dropdown(
      onPressed: () {
        WalletsRoute().push<void>(context);
      },
      leadingIcon: Avatar(
        size: 28.0.s,
        imageUrl: walletData.icon,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      leadingIconOffset: 11.0.s,
      trailingIconOffset: 0.0.s,
      backgroundColor: context.theme.appColors.tertararyBackground,
      label: Text(
        walletData.name,
        style: context.theme.appTextThemes.subtitle2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
