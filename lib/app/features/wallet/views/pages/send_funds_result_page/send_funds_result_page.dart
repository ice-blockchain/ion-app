import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_details.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_error_message.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_icon.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_message.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/modal_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_ui_model.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class SendFundsResultPage extends HookConsumerWidget {
  const SendFundsResultPage({required this.transaction, super.key});

  final TransactionUiModel transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showErrorDetails = useState(false);

    return ScreenBottomOffset(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              NavigationAppBar.modal(
                showBackButton: false,
                actions: const [NavigationCloseButton()],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0.s),
                  child: SendFundsResultIcon(transaction: transaction),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0.s),
          SendFundsResultMessage(transaction: transaction),
          SizedBox(height: 10.0.s),
          if (transaction.state == ModalState.transferSuccess)
            SizedBox(height: 6.0.s),
          if (transaction.state == ModalState.somethingWentWrong)
            SendFundsResultErrorMessage(
              transaction: transaction,
              showErrorDetails: showErrorDetails,
            ),
          SizedBox(height: 20.0.s),
          SendFundsResultDetails(
            transaction: transaction,
            showErrorDetails: showErrorDetails,
          ),
        ],
      ),
    );
  }
}
