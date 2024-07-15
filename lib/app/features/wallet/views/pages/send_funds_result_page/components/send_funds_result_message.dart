import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/modal_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_ui_model.dart';

class SendFundsResultMessage extends StatelessWidget {
  const SendFundsResultMessage({required this.transaction, super.key});

  final TransactionUiModel transaction;

  @override
  Widget build(BuildContext context) {
    switch (transaction.state) {
      case ModalState.transferSuccess:
        return Text(
          context.i18n.wallet_funds_successful,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        );
      case ModalState.somethingWentWrong:
        return Text(
          context.i18n.wallet_funds_error,
          style: context.theme.appTextThemes.title,
        );
    }
  }
}
