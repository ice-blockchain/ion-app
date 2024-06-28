import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TransactionResultSheet extends MyIcePage {
  const TransactionResultSheet({super.key});

  // const TransactionResultSheet(super.route, super.payload, {super.key});

  static const networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;
    final icons = Assets.images.icons;

    final formData = ref.watch(sendCoinsFormControllerProvider);

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40.0.s),
            icons.actionSendfunds.iconWithDimensions(
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
            TransactionAmountSummary(
              usdtAmount: formData.usdtAmount,
              usdAmount: formData.usdtAmount * 0.999,
              icon: mockedCoinsDataArray[3].iconUrl.icon(),
            ),
            SizedBox(height: 31.0.s),
            Button(
              label: Text(locale.wallet_transaction_details),
              leadingIcon: icons.iconButtonDetails.icon(),
              mainAxisSize: MainAxisSize.max,
              onPressed: () {},
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
