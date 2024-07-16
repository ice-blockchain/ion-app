import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coin_address_tile/coin_address_tile.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/model/coin_receive_modal_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CoinReceiveModal extends IcePage {
  const CoinReceiveModal({required this.payload, super.key});

  final CoinReceiveModalData payload;

  NetworkType _getNetworkType(CoinReceiveModalData data) {
    if (data.networkType == NetworkType.all) {
      return NetworkType.arbitrum;
    }
    return data.networkType;
  }

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    final networkType = _getNetworkType(payload);

    return SheetContent(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationAppBar.modal(
              showBackButton: false,
              title: context.i18n.wallet_receive,
              actions: const <Widget>[NavigationCloseButton()],
            ),
            ScreenSideOffset.small(
              child: CoinAddressTile(
                coinData: payload.coinData,
              ),
            ),
            SizedBox(
              height: 15.0.s,
            ),
            ScreenSideOffset.small(
              child: ListItem(
                title: Text(context.i18n.wallet_network),
                subtitle: Text(networkType.getDisplayName(context)),
                switchTitleStyles: true,
                leading: networkType.iconAsset.icon(size: 36.0.s),
                trailing: Text(
                  context.i18n.wallet_change,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
