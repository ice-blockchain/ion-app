// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_delete_event_provider.c.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/providers/transaction_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class MoneyMessageButton extends StatelessWidget {
  const MoneyMessageButton({
    required this.isMe,
    required this.messageType,
    required this.eventId,
    required this.isPaid,
    required this.eventMessage,
    required this.request,
    super.key,
  });

  final bool isMe;
  final MoneyMessageType messageType;
  final String eventId;
  final bool isPaid;
  final FundsRequestEntity request;
  final EventMessage eventMessage;

  static Size get _defaultMinimumSize => Size(150.0.s, 32.0.s);

  @override
  Widget build(BuildContext context) {
    if (isPaid) {
      return _ViewTransactionButton(request: request);
    } else if (isMe && messageType == MoneyMessageType.requested) {
      return _CancelMoneyRequestButton(eventMessage: eventMessage);
    } else if (!isMe && messageType == MoneyMessageType.requested) {
      return _SendMoneyButton(eventId: eventId, request: request);
    } else {
      // Default case - shouldn't happen with proper conditions
      throw ArgumentError('No appropriate button for the given parameters');
    }
  }
}

class _CancelMoneyRequestButton extends ConsumerWidget {
  const _CancelMoneyRequestButton({
    required this.eventMessage,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(e2eeDeleteMessageNotifierProvider(eventMessage: eventMessage)).isLoading;

    return Button.compact(
      type: ButtonType.outlined,
      backgroundColor: context.theme.appColors.tertararyBackground,
      minimumSize: MoneyMessageButton._defaultMinimumSize,
      disabled: isLoading,
      label: isLoading
          ? const IONLoadingIndicator()
          : Text(
              context.i18n.button_cancel,
              style: context.theme.appTextThemes.caption2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
      onPressed: () {
        ref
            .read(e2eeDeleteMessageNotifierProvider(eventMessage: eventMessage).notifier)
            .deleteMessage(forEveryone: true);
      },
    );
  }
}

class _SendMoneyButton extends ConsumerWidget {
  const _SendMoneyButton({
    required this.eventId,
    required this.request,
  });

  final String eventId;
  final FundsRequestEntity? request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sendAssetFormControllerProvider);

    return Button.compact(
      type: ButtonType.outlined,
      backgroundColor: context.theme.appColors.darkBlue,
      minimumSize: MoneyMessageButton._defaultMinimumSize,
      label: Text(
        context.i18n.button_send,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.onPrimaryAccent,
        ),
      ),
      onPressed: () async => _handleSendMoney(context, ref),
    );
  }

  Future<void> _handleSendMoney(BuildContext context, WidgetRef ref) async {
    if (request == null) return;
    const formName = 'send_coins_form_chat';

    try {
      ref.invalidate(sendAssetFormControllerProvider);
      final sendAssetFormController = ref.read(sendAssetFormControllerProvider.notifier);

      // Extract request data
      final receiverAddress = request?.data.content.to;
      final senderAddress = request?.data.content.from;
      final amount = request?.data.content.amount;
      final networkId = request?.data.networkId ?? '';
      final assetId = request?.data.content.assetId ?? '';
      final receiverPubkey = request?.pubkey;

      // Get required data from providers
      final network = await ref.read(networkByIdProvider(networkId).future);
      if (network == null) {
        throw FormException('Network not found', formName: formName);
      }

      final walletView = await ref.read(walletViewByAddressProvider(senderAddress ?? '').future);
      if (walletView == null) {
        throw FormException('Wallet not found', formName: formName);
      }

      final coinsInWalletView = await ref.read(coinsInWalletViewProvider(walletView.id).future);
      if (coinsInWalletView.isEmpty) {
        throw FormException('No coins found in wallet', formName: formName);
      }

      final coinGroup = coinsInWalletView.firstWhereOrNull(
        (cg) => cg.coins.any((c) => c.coin.id == assetId),
      );
      if (coinGroup == null) {
        throw FormException('Coin group not found', formName: formName);
      }

      await sendAssetFormController.setCoin(coinGroup, walletView);

      sendAssetFormController
        ..setRequest(request!)
        ..setContact(receiverPubkey, isContactPreselected: true)
        ..setReceiverAddress(receiverAddress ?? '');

      await sendAssetFormController.setNetwork(network);

      sendAssetFormController.setCoinsAmount(amount ?? '');

      if (!context.mounted) return;

      await SendCoinsFormChatRoute().push<void>(context);
    } catch (e) {
      if (context.mounted) {
        showErrorModal(context, e);
      }
    }
  }
}

class _ViewTransactionButton extends ConsumerWidget {
  const _ViewTransactionButton({
    required this.request,
  });

  final FundsRequestEntity request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Button.compact(
      backgroundColor: context.theme.appColors.darkBlue,
      tintColor: context.theme.appColors.darkBlue,
      minimumSize: MoneyMessageButton._defaultMinimumSize,
      label: Text(
        context.i18n.chat_money_received_button,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.onPrimaryAccent,
        ),
      ),
      onPressed: () async {
        final assetId = request.data.content.assetId;
        if (assetId == null) {
          return;
        }

        final coinData = await ref.read(coinByIdProvider(assetId).future);
        if (coinData == null) {
          return;
        }

        final coinGroup = CoinsGroup.fromCoin(coinData);

        ref.read(transactionNotifierProvider.notifier).details =
            TransactionDetails.fromTransactionData(
          request.data.transaction!,
          coinsGroup: coinGroup,
        );

        if (!context.mounted) {
          return;
        }
        unawaited(CoinTransactionResultChatRoute().push<void>(context));
      },
    );
  }
}
