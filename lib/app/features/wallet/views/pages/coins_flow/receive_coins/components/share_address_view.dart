import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/info_card.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/receive_info_card.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareAddressView extends IcePage<Map<String, dynamic>?> {
  const ShareAddressView(super.route, super.payload, {super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic>? payload,
  ) {
    final arguments = payload!;
    final coinData = arguments['coinData'] as CoinData;
    final networkType = arguments['networkType'] as NetworkType;

    const walletAddress = '0x122abc456def789ghij012klmno345pqrs678tuv';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: UiSize.xxSmall),
          child: NavigationAppBar.screen(
            title: context.i18n.wallet_share_address,
            actions: const <Widget>[
              NavigationCloseButton(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: UiSize.medium),
          child: Column(
            children: <Widget>[
              ReceiveInfoCard(
                coinData: coinData,
                networkType: networkType,
                walletAddress: walletAddress,
              ),
              SizedBox(
                height: UiSize.medium,
              ),
              const InfoCard(),
              SizedBox(
                height: UiSize.medium,
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
    );
  }
}
