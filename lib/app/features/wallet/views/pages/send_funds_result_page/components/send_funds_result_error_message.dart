import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_ui_model.dart';

class SendFundsResultErrorMessage extends StatelessWidget {
  const SendFundsResultErrorMessage({
    required this.transaction,
    required this.showErrorDetails,
    super.key,
  });

  final TransactionUiModel transaction;
  final ValueNotifier<bool> showErrorDetails;

  @override
  Widget build(BuildContext context) {
    final error = transaction.state as Error;
    return Column(
      children: [
        if (!showErrorDetails.value)
          TextButton(
            onPressed: () {
              showErrorDetails.value = !showErrorDetails.value;
            },
            child: Text(
              context.i18n.wallet_funds_show_error,
              style: context.theme.appTextThemes.caption
                  .copyWith(color: context.theme.appColors.primaryAccent),
            ),
          ),
        if (showErrorDetails.value)
          ScreenSideOffset.small(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.appColors.tertararyBackground,
                borderRadius: BorderRadius.circular(16.0.s),
                border: Border.all(
                  color: context.theme.appColors.onTerararyFill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.s,
                  horizontal: 16.0.s,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  error.errorDetails,
                  style: context.theme.appTextThemes.body,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
