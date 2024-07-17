import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';
import 'package:ice/generated/assets.gen.dart';

class SendFundsResultIcon extends StatelessWidget {
  const SendFundsResultIcon({required this.transactionState, super.key});

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return switch (transactionState) {
      SuccessSendTransactionState() =>
        Assets.images.icons.actionSendfunds.iconWithDimensions(
          width: 74.0.s,
          height: 76.0.s,
        ),
      SuccessContactTransactionState() =>
        Assets.images.misc.actionContactsendSuccess.iconWithDimensions(
          width: 63.0.s,
          height: 76.0.s,
        ),
      ErrorTransactionState() =>
        Assets.images.misc.actionContactsendError.iconWithDimensions(
          width: 65.0.s,
          height: 76.0.s,
        ),
    };
  }
}
