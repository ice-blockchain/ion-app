import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class CoinDetailsPage extends IcePage<CoinData> {
  const CoinDetailsPage(super.route, super.payload);

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    CoinData? coinData,
  ) {
    final ScrollController scrollController = useScrollController();
    if (coinData == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: coinData.name,
        titleIcon: coinData.iconUrl.icon(),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Delimiter(),
                Balance(
                  coinData: coinData,
                ),
                const Delimiter(),
              ],
            ),
          ),
          const EmptyState(),
        ],
      ),
    );
  }
}
