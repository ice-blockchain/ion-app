import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/modal_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_ui_model.dart';
import 'package:ice/generated/assets.gen.dart';

class SendFundsResultIcon extends StatelessWidget {
  const SendFundsResultIcon({required this.transaction, super.key});

  final TransactionUiModel transaction;

  @override
  Widget build(BuildContext context) {
    switch (transaction.state) {
      case ModalState.transferSuccess:
        return Assets.images.misc.actionContactsendSuccess.icon(size: 80.0.s);
      case ModalState.somethingWentWrong:
        return Assets.images.misc.actionContactsendError.icon(size: 80.0.s);
    }
  }
}
