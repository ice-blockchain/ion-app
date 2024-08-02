import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/nft_item/nft_item.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ice/app/features/wallet/views/pages/transaction_details/transaction_details_actions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key, required this.type});

  final CryptoAssetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    final controller = ref.watch(sendAssetFormControllerProvider(type: type).notifier);
    final formData = ref.watch(sendAssetFormControllerProvider(type: type));

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.transaction_details_title),
            showBackButton: false,
            actions: const [NavigationCloseButton()],
          ),
          ScreenSideOffset.small(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.0.s),
              child: Column(
                children: [
                  if (type == CryptoAssetType.nft)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 52.0.s,
                      ),
                      child: NftItem(
                        nftData: formData.selectedNft!,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  if (type == CryptoAssetType.coin)
                    TransactionAmountSummary(
                      usdtAmount: controller.getUsdtAmount(),
                      usdAmount: controller.getUsdtAmount() * 0.999,
                      icon: mockedCoinsDataArray[3].iconUrl.icon(),
                    ),
                  SizedBox(height: 12.0.s),
                  Timeline(
                    items: [
                      TimelineItemData(title: 'Pending', isDone: true, date: DateTime.now()),
                      TimelineItemData(title: 'In the process of execution', isDone: true),
                      TimelineItemData(title: 'Transaction successful', isDone: false),
                    ],
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_send_to),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formData.address,
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: formData.wallet.name,
                    icon: Image.network(
                      formData.wallet.icon,
                      width: ScreenSideOffset.defaultSmallMargin,
                      height: ScreenSideOffset.defaultSmallMargin,
                    ),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.text(
                    title: Text(context.i18n.send_nft_confirm_asset),
                    value: controller.getAsset(),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(context.i18n.send_nft_confirm_network),
                    value: controller.getNetwork(),
                    icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_arrival_time),
                    value: '${formData.arrivalTime} '
                        '${locale.wallet_arrival_time_minutes}',
                    icon: Assets.images.icons.iconBlockTime.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_network_fee),
                    value: '1.00 USDT',
                    icon: Assets.images.icons.iconBlockCoins.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 15.0.s),
                  TransactionDetailsActions(
                    onViewOnExplorer: () {
                      WebViewBrowserRoute(
                              $extra:
                                  'https://etherscan.io/address/0x1f9090aae28b8a3dceadf281b0f12828e676c326')
                          .push<void>(context);
                    },
                    onShare: () {},
                  ),
                  SizedBox(height: 8.0.s),
                ],
              ),
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
