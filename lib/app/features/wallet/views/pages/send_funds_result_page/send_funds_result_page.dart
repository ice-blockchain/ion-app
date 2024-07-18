import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_details.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_error_message.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_icon.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/components/send_funds_result_message.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SendFundsResultPage extends HookConsumerWidget {
  const SendFundsResultPage({required this.transactionState, super.key});

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showErrorDetails = useState(false);

    return SheetContent(
      body: ScreenBottomOffset(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TransactionIcon(
              transactionState: transactionState,
            ),
            SizedBox(height: 10.0.s),
            SendFundsResultMessage(transactionState: transactionState),
            SizedBox(height: 10.0.s),
            _TransactionBody(
              transactionState: transactionState,
              showErrorDetails: showErrorDetails,
            ),
            SizedBox(height: 20.0.s),
            SendFundsResultDetails(
              transactionState: transactionState,
              showErrorDetails: showErrorDetails,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionBody extends StatelessWidget {
  const _TransactionBody({
    required this.transactionState,
    required this.showErrorDetails,
  });

  final TransactionState transactionState;
  final ValueNotifier<bool> showErrorDetails;

  @override
  Widget build(BuildContext context) {
    return switch (transactionState) {
      SuccessSendTransactionState() => SizedBox(height: 6.0.s),
      SuccessContactTransactionState() => SizedBox(height: 6.0.s),
      ErrorTransactionState() => SendFundsResultErrorMessage(
          transactionState: transactionState,
          showErrorDetails: showErrorDetails,
        ),
    };
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({
    required this.transactionState,
  });

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return switch (transactionState) {
      SuccessSendTransactionState() =>
        _BuildIcon(transactionState: transactionState),
      SuccessContactTransactionState() =>
        _BuildIconWithClose(transactionState: transactionState),
      ErrorTransactionState() =>
        _BuildIconWithClose(transactionState: transactionState),
    };
  }
}

class _BuildIcon extends StatelessWidget {
  const _BuildIcon({
    required this.transactionState,
  });

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 40.0.s),
            child: SendFundsResultIcon(transactionState: transactionState),
          ),
        ),
      ],
    );
  }
}

class _BuildIconWithClose extends StatelessWidget {
  const _BuildIconWithClose({
    required this.transactionState,
  });

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          actions: const [NavigationCloseButton()],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 40.0.s),
            child: SendFundsResultIcon(transactionState: transactionState),
          ),
        ),
      ],
    );
  }
}
