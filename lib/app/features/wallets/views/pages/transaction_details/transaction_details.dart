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
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/model/transfer_status.c.dart';
import 'package:ion/app/features/wallets/providers/transaction_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/list_item_arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/list_item_network_fee.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/components/nft_item.dart';
import 'package:ion/app/features/wallets/views/components/timeline/timeline.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ion/app/features/wallets/views/pages/transaction_details/transaction_details_actions.dart';
import 'package:ion/app/features/wallets/views/send_to_recipient.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/share/share.dart';
import 'package:ion/generated/assets.gen.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({
    required this.exploreRouteLocationBuilder,
    super.key,
  });

  final String Function(String url) exploreRouteLocationBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final transactionData = ref.watch(transactionNotifierProvider)!;

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
                    transactionData.assetData.maybeMap(
                          coin: (coin) => TransactionAmountSummary(
                            amount: coin.amount,
                            currency: coin.coinsGroup.abbreviation,
                            usdAmount: coin.amountUSD,
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
                          orElse: () => const SizedBox(),
                        ) ??
                        const SizedBox(),
                    SizedBox(height: 12.0.s),
                    Timeline(
                      items: [
                        TimelineItemData(
                          title: locale.transaction_details_timeline_pending,
                          isDone: true,
                          date: transactionData.dateRequested,
                        ),
                        TimelineItemData(
                          title: locale.transaction_details_timeline_executing,
                          isDone: transactionData.dateBroadcasted != null,
                        ),
                        TimelineItemData(
                          title: locale.transaction_details_timeline_successful,
                          isDone: transactionData.dateConfirmed != null &&
                              transactionData.status == TransactionStatus.confirmed,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0.s),
                    SendToRecipient(
                      address: transactionData.receiverAddress,
                      pubkey: transactionData.receiverPubkey,
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_title),
                      value: transactionData.walletViewName,
                      icon: Assets.svg.walletWalletblue.icon(
                        size: ScreenSideOffset.defaultSmallMargin,
                      ),
                      secondary: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          transactionData.senderAddress,
                          textAlign: TextAlign.right,
                          style: context.theme.appTextThemes.caption3.copyWith(),
                        ),
                      ),
                    ),
                    ...transactionData.assetData.maybeMap(
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
                      value: transactionData.network.displayName,
                      icon: NetworkIconWidget(
                        size: 16.0.s,
                        imageUrl: transactionData.network.image,
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    if (transactionData.networkFeeOption != null) ...[
                      ListItemArrivalTime(
                        formattedTime:
                            transactionData.networkFeeOption!.getDisplayArrivalTime(context),
                      ),
                      SizedBox(height: 12.0.s),
                      ListItemNetworkFee(
                        value: formatCrypto(
                          transactionData.networkFeeOption!.amount,
                          transactionData.networkFeeOption!.symbol,
                        ),
                      ),
                    ],
                    SizedBox(height: 15.0.s),
                    TransactionDetailsActions(
                      onViewOnExplorer: () {
                        final url = transactionData.transactionExplorerUrl;
                        final location = exploreRouteLocationBuilder(url);
                        context.push<void>(location);
                      },
                      onShare: () => shareContent(transactionData.transactionExplorerUrl),
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
