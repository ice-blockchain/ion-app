import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_success_send_button.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_summary.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';
import 'package:ice/generated/assets.gen.dart';

class SendFundsResultDetails extends StatelessWidget {
  const SendFundsResultDetails({
    required this.transactionState,
    required this.showErrorDetails,
    super.key,
  });

  final TransactionState transactionState;
  final ValueNotifier<bool> showErrorDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        switch (transactionState) {
          SuccessContactTransactionState(coin: final coin, type: final type) =>
            SendFundsSummary(
              type: type,
              coin: coin,
            ),
          SuccessSendTransactionState(coin: final coin, type: final type) =>
            SendFundsSummary(
              type: type,
              coin: coin,
            ),
          ErrorTransactionState(coin: final coin, type: final type) =>
            SendFundsSummary(
              type: type,
              coin: coin,
            ),
        },
        switch (transactionState) {
          SuccessSendTransactionState() => Column(
              children: [
                SizedBox(height: 31.0.s),
                const SendFundsSuccessSendButton(),
              ],
            ),
          SuccessContactTransactionState() => Column(
              children: [
                SizedBox(height: 29.0.s),
                const _BuildButtonSection(),
              ],
            ),
          ErrorTransactionState() => const _BuildErrorSection(),
        },
      ],
    );
  }
}

class _BuildErrorSection extends StatelessWidget {
  const _BuildErrorSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}

class _BuildButtonSection extends StatelessWidget {
  const _BuildButtonSection();

  @override
  Widget build(BuildContext context) {
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
