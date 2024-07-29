import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/nft_item/nft_item.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final nftFormData = ref.watch(sendNftFormControllerProvider);
    final coinFormData = ref.watch(sendCoinsFormControllerProvider);
    final selectedNft = nftFormData.selectedNft;
    final selectedCoin = coinFormData.selectedCoin;

    final address = selectedNft != null ? nftFormData.address : coinFormData.address;
    final wallet = selectedNft != null ? nftFormData.wallet : coinFormData.wallet;
    final asset =
        selectedNft != null ? nftFormData.selectedNft!.asset : coinFormData.selectedCoin!.asset;
    final network =
        selectedNft != null ? nftFormData.selectedNft!.network : coinFormData.selectedCoin!.network;
    final arrivalTime = selectedNft != null ? nftFormData.arrivalTime : coinFormData.arrivalTime;

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
                  if (selectedNft != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 52.0.s,
                      ),
                      child: NftItem(
                        nftData: selectedNft,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  if (selectedCoin != null && coinFormData.usdtAmount != null)
                    TransactionAmountSummary(
                      usdtAmount: coinFormData.usdtAmount!,
                      usdAmount: coinFormData.usdtAmount! * 0.999,
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
                        address,
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: wallet.name,
                    icon: Image.network(
                      wallet.icon,
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
                    value: asset,
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(context.i18n.send_nft_confirm_network),
                    value: network,
                    icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_arrival_time),
                    value: '${arrivalTime} '
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
                  SizedBox(height: 12.0.s),
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
