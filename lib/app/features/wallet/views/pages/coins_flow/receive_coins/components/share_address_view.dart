import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/info_card.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/receive_info_card.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareAddressView extends IcePage {
  const ShareAddressView({required this.payload, super.key});

  final Map<String, dynamic> payload;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    final arguments = payload;
    final coinData = arguments['coinData'] as CoinData;
    final networkType = arguments['networkType'] as NetworkType;

    const walletAddress = '0x122abc456def789ghij012klmno345pqrs678tuv';

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: context.i18n.wallet_share_address,
              actions: const [
                NavigationCloseButton(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: Column(
              children: [
                ReceiveInfoCard(
                  coinData: coinData,
                  networkType: networkType,
                  walletAddress: walletAddress,
                ),
                SizedBox(
                  height: 16.0.s,
                ),
                const InfoCard(),
                SizedBox(
                  height: 16.0.s,
                ),
                Button.compact(
                  mainAxisSize: MainAxisSize.max,
                  minimumSize: Size(56.0.s, 56.0.s),
                  leadingIcon: Assets.images.icons.iconButtonSend.icon(),
                  label: Text(
                    context.i18n.wallet_share,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
