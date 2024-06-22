import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/search_bar/search_bar.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class CoinsTabHeader extends StatelessWidget {
  const CoinsTabHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: Padding(
          padding: EdgeInsets.only(top: UiSize.xxSmall),
          child: WalletSearchBar(
            padding: EdgeInsets.only(
              bottom: UiSize.medium,
            ),
            tabType: WalletTabType.coins,
          ),
        ),
      ),
    );
  }
}
