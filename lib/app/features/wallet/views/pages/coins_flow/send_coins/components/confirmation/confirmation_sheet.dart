import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';
// import 'package:ice/generated/assets.gen.dart';

class ConfirmationSheet extends IcePage {
  const ConfirmationSheet({super.key});

  static const networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formData = ref.watch(sendCoinsFormControllerProvider);

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s),
              child: NavigationAppBar.screen(
                title: locale.wallet_send_coins,
                actions: const <Widget>[
                  NavigationCloseButton(),
                ],
              ),
            ),
            ScreenSideOffset.small(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16.0.s),
                  TransactionAmountSummary(
                    usdtAmount: formData.usdtAmount,
                    usdAmount: formData.usdtAmount * 0.999,
                    icon: mockedCoinsDataArray[3].iconUrl.icon(),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.text(
                    title: Text(locale.wallet_send_to),
                    value: formData.address,
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_asset),
                    value: formData.selectedCoin.name,
                    icon: formData.selectedCoin.iconUrl.icon(
                      size: ScreenSideOffset.defaultSmallMargin,
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: formData.wallet.name,
                    icon: Image.network(
                      formData.wallet.icon,
                      width: ScreenSideOffset.defaultSmallMargin,
                      height: ScreenSideOffset.defaultSmallMargin,
                    ),
                    secondaryValue:
                        '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_network),
                    value: formData.selectedNetwork.name,
                    icon: formData.selectedNetwork.iconAsset.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_arrival_time),
                    value: '${formData.arrivalTime} '
                        '${locale.wallet_arrival_time_minutes}',
                    icon: Assets.images.icons.iconBlockTime.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_network_fee),
                    value: '1.00 USDT',
                    icon: Assets.images.icons.iconBlockCoins.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 22.0.s),
                  Button(
                    label: Text('${locale.wallet_send_coins} - \$351.35'),
                    mainAxisSize: MainAxisSize.max,
                    onPressed: () => TransactionResultRoute().go(context),
                  ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
