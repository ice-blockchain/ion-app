// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/components/nft_item/nft_item.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class TransactionResultSheet extends ConsumerWidget {
  const TransactionResultSheet({required this.type, super.key});

  final CryptoAssetType type;

  static const networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(sendAssetFormControllerProvider(type: type).notifier);
    final formData = ref.watch(sendAssetFormControllerProvider(type: type));

    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;
    const icons = Assets.svg;

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              actions: const [
                NavigationCloseButton(),
              ],
            ),
            icons.actionContactsendSuccess.iconWithDimensions(
              width: 74.0.s,
              height: 76.0.s,
            ),
            SizedBox(height: 10.0.s),
            Text(
              locale.wallet_transaction_successful,
              style: textTheme.title.copyWith(
                color: colors.primaryAccent,
              ),
            ),
            SizedBox(height: 24.0.s),
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
                amount: controller.amount,
                currency: formData.selectedCoin!.abbreviation,
                usdAmount: controller.amount * 0.999,
                icon: formData.selectedCoin!.iconUrl.icon(),
              ),
            SizedBox(height: 24.0.s),
            Row(
              children: [
                Expanded(
                  child: Button(
                    label: Text(locale.wallet_transaction_details),
                    leadingIcon: icons.iconButtonDetails.icon(
                      color: context.theme.appColors.secondaryText,
                    ),
                    backgroundColor: context.theme.appColors.tertararyBackground,
                    type: ButtonType.outlined,
                    mainAxisSize: MainAxisSize.max,
                    onPressed: () {
                      final location = switch (type) {
                        CryptoAssetType.coin => CoinTransactionDetailsRoute().location,
                        CryptoAssetType.nft => NftTransactionDetailsRoute().location,
                      };
                      context.push(location);
                    },
                  ),
                ),
                SizedBox(width: 13.0.s),
                Button(
                  type: ButtonType.outlined,
                  onPressed: () {},
                  backgroundColor: context.theme.appColors.tertararyBackground,
                  leadingIcon: icons.iconButtonShare.icon(),
                ),
              ],
            ),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}
