import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/nft_item/nft_item.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TransactionResultSheet extends ConsumerWidget {
  const TransactionResultSheet({super.key, required this.type});

  final CryptoAssetType type;

  static const networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(sendAssetFormControllerProvider(type: type).notifier);
    final formData = ref.watch(sendAssetFormControllerProvider(type: type));

    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;
    final icons = Assets.svg;

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40.0.s),
            icons.actionSendfundsSuccessful.iconWithDimensions(
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
            SizedBox(height: 36.0.s),
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
            SizedBox(height: 31.0.s),
            Button(
              label: Text(locale.wallet_transaction_details),
              leadingIcon: icons.iconButtonDetails.icon(),
              mainAxisSize: MainAxisSize.max,
              onPressed: () {
                CoinTransactionDetailsRoute(cryptoAssetType: type).push<void>(context);
              },
            ),
            SizedBox(height: 12.0.s),
            Row(
              children: [
                Expanded(
                  child: Button(
                    type: ButtonType.outlined,
                    onPressed: () {},
                    leadingIcon: icons.iconButtonShare.icon(),
                    label: Text(locale.wallet_share),
                  ),
                ),
                SizedBox(width: 13.0.s),
                Expanded(
                  child: Button(
                    type: ButtonType.outlined,
                    onPressed: () => Navigator.pop(context),
                    leadingIcon: icons.iconSheetClose.icon(
                      color: colors.secondaryText,
                    ),
                    label: Text(locale.button_close),
                  ),
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
