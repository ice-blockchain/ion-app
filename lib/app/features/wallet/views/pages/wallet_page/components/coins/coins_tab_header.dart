import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
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
          padding: EdgeInsets.only(top: 8.0.s),
          child: WalletSearchBar(
            padding: EdgeInsets.only(
              bottom: 16.0.s,
            ),
            tabType: WalletTabType.coins,
          ),
        ),
      ),
    );
  }
}
