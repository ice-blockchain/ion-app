// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/timeline_item_data.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/list_item_network_fee.dart';
import 'package:ion/app/features/wallets/views/components/nft_item.dart';
import 'package:ion/app/features/wallets/views/components/timeline/timeline.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ion/app/features/wallets/views/pages/transaction_details/transaction_details_actions.dart';
import 'package:ion/app/features/wallets/views/send_to_recipient.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({required this.type, super.key});

  final CryptoAssetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final formData = ref.watch(sendAssetFormControllerProvider(type: type));

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.transaction_details_title),
              actions: const [NavigationCloseButton()],
            ),
            ScreenSideOffset.small(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.0.s),
                child: Column(
                  children: [
                    formData.assetData!.map(
                      coin: (coin) => TransactionAmountSummary(
                        amount: coin.amount,
                        currency: coin.coinsGroup.abbreviation,
                        // usdAmount: coin.usdAmount, // TODO: Not implemented
                        usdAmount: 0,
                        icon: CoinIconWidget(
                          imageUrl: coin.coinsGroup.iconUrl,
                        ),
                      ),
                      nft: (nft) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 52.0.s,
                        ),
                        child: NftItem(
                          nftData: nft.nft,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    Timeline(
                      items: [
                        TimelineItemData(title: 'Pending', isDone: true, date: DateTime.now()),
                        TimelineItemData(title: 'In the process of execution', isDone: true),
                        TimelineItemData(title: 'Transaction successful'),
                      ],
                    ),
                    SizedBox(height: 16.0.s),
                    SendToRecipient(
                      address: formData.receiverAddress,
                      pubkey: formData.contactPubkey,
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_title),
                      value: formData.wallet.name,
                      icon: Assets.svg.walletWalletblue.icon(
                        size: ScreenSideOffset.defaultSmallMargin,
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
                    ...formData.assetData?.maybeMap(
                          coin: (coin) => [
                            SizedBox(height: 16.0.s),
                            ListItem.textWithIcon(
                              title: Text(locale.wallet_asset),
                              value: coin.coinsGroup.name,
                              icon: CoinIconWidget(
                                imageUrl: coin.coinsGroup.iconUrl,
                                size: ScreenSideOffset.defaultSmallMargin,
                              ),
                            ),
                          ],
                          orElse: () => const [SizedBox.shrink()],
                        ) ??
                        const [SizedBox.shrink()],
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(context.i18n.send_nft_confirm_network),
                      value: formData.network.displayName,
                      icon: formData.network.svgIconAsset.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    // TODO: Not implemented
                    // ListItemArrivalTime(
                    //   arrivalTime: DateFormat(locale.wallet_transaction_details_arrival_time_format)
                    //       .format(formData.arrivalDateTime),
                    // ),
                    SizedBox(height: 12.0.s),
                    const ListItemNetworkFee(value: '1.00 USDT'),
                    SizedBox(height: 15.0.s),
                    TransactionDetailsActions(
                      onViewOnExplorer: () {
                        const url =
                            'https://etherscan.io/address/0x1f9090aae28b8a3dceadf281b0f12828e676c326';
                        final location = switch (type) {
                          CryptoAssetType.coin => ExploreCoinTransactionDetailsRoute(
                              url: url,
                            ).location,
                          CryptoAssetType.nft => ExploreNftTransactionDetailsRoute(
                              url: url,
                            ).location,
                        };

                        context.push<void>(location);
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
      ),
    );
  }
}
