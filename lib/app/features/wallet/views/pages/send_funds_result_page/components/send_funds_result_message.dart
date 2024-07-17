import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';

class SendFundsResultMessage extends StatelessWidget {
  const SendFundsResultMessage({required this.transactionState, super.key});

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return switch (transactionState) {
      SuccessSendTransactionState() => Text(
          context.i18n.wallet_funds_successful,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      SuccessContactTransactionState() => Text(
          context.i18n.wallet_funds_successful,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ErrorTransactionState() => Text(
          context.i18n.wallet_funds_error,
          style: context.theme.appTextThemes.title,
        ),
    };
  }
}
