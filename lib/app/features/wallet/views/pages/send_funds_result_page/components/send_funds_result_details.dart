import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/modal_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_type.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_ui_model.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class SendFundsResultDetails extends StatelessWidget {
  const SendFundsResultDetails({
    required this.transaction,
    required this.showErrorDetails,
    super.key,
  });

  final TransactionUiModel transaction;
  final ValueNotifier<bool> showErrorDetails;

  @override
  Widget build(BuildContext context) {
    final text = '${formatToCurrency(transaction.coin.amount, '')} '
        '${transaction.coin.abbreviation}';
    if (transaction.type == TransactionType.coin) {
      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              transaction.coin.iconUrl.icon(size: 24.0.s),
              SizedBox(width: 12.0.s),
              Text(
                text,
                style: context.theme.appTextThemes.headline2,
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Text(
            '~ ${formatToCurrency(transaction.coin.balance)}',
            style: context.theme.appTextThemes.subtitle2.copyWith(
              color: context.theme.appColors.onTertararyBackground,
            ),
          ),
          if (transaction.state == ModalState.transferSuccess) ...[
            SizedBox(height: 29.0.s),
            _buildButtons(context),
          ],
          if (transaction.state == ModalState.somethingWentWrong) ...[
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Button.compact(
                mainAxisSize: MainAxisSize.max,
                minimumSize: Size(56.0.s, 56.0.s),
                leadingIcon: Assets.images.icons.iconButtonTryagain.icon(),
                label: Text(
                  context.i18n.wallet_try_again,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ],
      );
    } else if (transaction.type == TransactionType.nft) {
      //TODO: Implement nft UI
      return const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildButtons(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: Button.compact(
              type: ButtonType.secondary,
              minimumSize: Size(56.0.s, 56.0.s),
              leadingIcon: Assets.images.icons.iconButtonInternet.icon(),
              label: Text(
                context.i18n.wallet_funds_view_explorer,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 13.0.s),
          Button.icon(
            type: ButtonType.secondary,
            icon: Assets.images.icons.iconButtonShare.icon(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
