import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/receive_coins/components/info_card.dart';
import 'package:ice/app/features/wallet/views/pages/receive_coins/components/receive_info_card.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareAddressView extends IcePage<Map<String, dynamic>?> {
  const ShareAddressView(super.route, super.payload);

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  static EdgeInsetsGeometry verticalPadding =
      EdgeInsets.symmetric(vertical: 8.0.s);
  static EdgeInsetsGeometry horizontalPadding =
      EdgeInsets.symmetric(horizontal: 16.0.s);
  static SizedBox sizedBoxHeight16 = SizedBox(height: 16.0.s);

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic>? data,
  ) {
    final Map<String, dynamic> arguments = data!;
    final CoinData coinData = arguments['coinData'] as CoinData;
    final NetworkType networkType = arguments['networkType'] as NetworkType;

    const String walletAddress = '0x122abc456def789ghij012klmno345pqrs678tuv';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: verticalPadding,
          child: NavigationAppBar.screen(
            title: context.i18n.wallet_share_address,
            actions: const <Widget>[
              NavigationCloseButton(),
            ],
          ),
        ),
        Padding(
          padding: horizontalPadding,
          child: Column(
            children: <Widget>[
              ReceiveInfoCard(
                coinData: coinData,
                networkType: networkType,
                walletAddress: walletAddress,
              ),
              sizedBoxHeight16,
              const InfoCard(),
              sizedBoxHeight16,
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
