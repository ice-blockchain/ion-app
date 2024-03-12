import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/constants.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class WalletTabsHeaderTab extends StatelessWidget {
  const WalletTabsHeaderTab({
    super.key,
    required this.isActive,
    required this.tabType,
    required this.onTap,
  });

  final bool isActive;
  final WalletTabType tabType;
  final VoidCallback onTap;

  String getTitle(BuildContext context) {
    switch (tabType) {
      case WalletTabType.coins:
        return context.i18n.core_coins;
      case WalletTabType.nfts:
        return context.i18n.core_nfts;
    }
  }

  Color getColor(BuildContext context) {
    return isActive
        ? context.theme.appColors.primaryText
        : context.theme.appColors.tertararyText;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.all(Constants.hitSlop),
        child: Text(
          getTitle(context),
          style: context.theme.appTextThemes.title.copyWith(
            color: getColor(context),
          ),
        ),
      ),
    );
  }
}
