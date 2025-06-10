// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message_service.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/wallets/data/models/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/send_asset_form_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_details.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_status.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_type.dart';
import 'package:ion/app/features/wallets/data/models/transfer_result.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/send_transaction_to_relay_service.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/retry.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_coins_notifier_provider.c.g.dart';

@riverpod
class SendCoinsNotifier extends _$SendCoinsNotifier {
  static const _formName = 'SendCoins';
  static const _maxRetries = 5;
  static const _initialRetryDelay = Duration(seconds: 1);

  @override
  FutureOr<TransactionDetails?> build() {
    return null;
  }

  Future<void> send(OnVerifyIdentity<Map<String, dynamic>> onVerifyIdentity) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final form = ref.read(sendAssetFormControllerProvider);

      final coinAssetData = _extractCoinAssetData(form);
      final (senderWallet, sendableAsset) = _validateFormComponents(form, coinAssetData);

      final walletViewId = await ref.read(currentWalletViewIdProvider.future);

      var result = await _executeCoinTransfer(
        coinAssetData: coinAssetData,
        senderWallet: senderWallet,
        sendableAsset: sendableAsset,
        form: form,
        onVerifyIdentity: onVerifyIdentity,
      );

      result = await _waitForTransactionCompletion(senderWallet.id, result);
      _validateTransactionResult(result, coinAssetData);

      Logger.info('Transaction was successful. Hash: ${result.txHash}');

      final coinsService = await ref.read(coinsServiceProvider.future);
      final nativeCoin = await coinsService.getNativeCoin(form.network!);

      final details = TransactionDetails(
        id: result.id,
        walletViewId: walletViewId,
        txHash: result.txHash!,
        network: form.network!,
        status: result.status,
        type: TransactionType.send,
        dateRequested: result.dateRequested,
        dateConfirmed: result.dateConfirmed,
        dateBroadcasted: result.dateBroadcasted,
        assetData: coinAssetData.copyWith(
          rawAmount: result.requestBody['amount'].toString(),
        ),
        nativeCoin: nativeCoin,
        walletViewName: form.walletView!.name,
        senderAddress: senderWallet.address,
        receiverAddress: form.receiverAddress,
        participantPubkey: form.contactPubkey,
        networkFeeOption: form.selectedNetworkFeeOption,
      );

      try {
        await _saveTransaction(
          details: details,
          transferResult: result,
          sendableAsset: sendableAsset,
          coinAssetData: coinAssetData,
          requestEntity: form.request,
          senderAddress: senderWallet.address,
          receiverAddress: form.receiverAddress,
        );
      } on SendEventException catch (e, stacktrace) {
        Logger.error('Failed to send event $e', stackTrace: stacktrace);
      }

      unawaited(
        ref.read(syncedCoinsBySymbolGroupNotifierProvider.notifier).refresh(
          [coinAssetData.coinsGroup.symbolGroup],
        ),
      );

      return details;
    });

    if (state.hasError) {
      // Log to get the error stack trace
      Logger.error(state.error!, stackTrace: state.stackTrace);
    }
  }

  CoinAssetToSendData _extractCoinAssetData(SendAssetFormData form) {
    if (form.assetData is! CoinAssetToSendData) {
      final error = FormException('Asset data must be CoinAssetToSendData', formName: _formName);
      Logger.error(error, message: 'Cannot send coins: asset data is not a coin asset');
      throw error;
    }
    return form.assetData as CoinAssetToSendData;
  }

  (Wallet senderWallet, WalletAsset sendableAsset) _validateFormComponents(
    SendAssetFormData form,
    CoinAssetToSendData coinAssetData,
  ) {
    final senderWallet = form.senderWallet;
    final sendableAsset = coinAssetData.associatedAssetWithSelectedOption;

    if (senderWallet == null) {
      final error = FormException('Sender wallet is required', formName: _formName);
      Logger.error(error, message: 'Cannot send coins: senderWallet is missing');
      throw error;
    }

    if (sendableAsset == null) {
      final error = FormException('Sendable asset is required', formName: _formName);
      Logger.error(error, message: 'Cannot send coins: sendableAsset is missing');
      throw error;
    }

    return (senderWallet, sendableAsset);
  }

  Future<TransferResult> _executeCoinTransfer({
    required CoinAssetToSendData coinAssetData,
    required Wallet senderWallet,
    required WalletAsset sendableAsset,
    required SendAssetFormData form,
    required OnVerifyIdentity<Map<String, dynamic>> onVerifyIdentity,
  }) async {
    final coinsService = await ref.read(coinsServiceProvider.future);

    return coinsService.send(
      amount: coinAssetData.amount,
      senderWallet: senderWallet,
      sendableAsset: sendableAsset,
      onVerifyIdentity: onVerifyIdentity,
      receiverAddress: form.receiverAddress,
      feeType: form.selectedNetworkFeeOption?.type,
    );
  }

  Future<TransferResult> _waitForTransactionCompletion(
    String walletId,
    TransferResult result,
  ) async {
    final coinsService = await ref.read(coinsServiceProvider.future);

    if (!_isRetryableStatus(result.status)) {
      return result;
    }

    // Transaction is still processing, wait for completion
    return withRetry<TransferResult>(
      ({Object? error}) async {
        final response = await coinsService.getTransfer(
          walletId: walletId,
          transferId: result.id,
        );

        if (_isRetryableStatus(response.status)) {
          throw InappropriateTransferStatusException();
        }

        return response;
      },
      maxRetries: _maxRetries,
      initialDelay: _initialRetryDelay,
      retryWhen: (result) => result is InappropriateTransferStatusException,
    );
  }

  bool _isRetryableStatus(TransactionStatus status) =>
      status == TransactionStatus.pending || status == TransactionStatus.executing;

  void _validateTransactionResult(TransferResult result, CoinAssetToSendData coinAssetData) {
    if (result.status == TransactionStatus.rejected || result.status == TransactionStatus.failed) {
      throw _createTransactionException(result.reason, coinAssetData);
    }
  }

  Exception _createTransactionException(String? reason, CoinAssetToSendData coinAssetData) {
    return switch (reason) {
      'paymentNoDestination' => PaymentNoDestinationException(
          abbreviation: coinAssetData.coinsGroup.abbreviation,
        ),
      _ => FailedToSendCryptoAssetsException(reason),
    };
  }

  Future<void> _saveTransaction({
    required WalletAsset sendableAsset,
    required TransactionDetails details,
    required TransferResult transferResult,
    required CoinAssetToSendData coinAssetData,
    required FundsRequestEntity? requestEntity,
    required String? senderAddress,
    required String? receiverAddress,
  }) async {
    // Save transaction into DB
    await ref.read(transactionsRepositoryProvider.future).then(
          (repo) => repo.saveTransactionDetails(details),
        );

    if (details.participantPubkey == null || senderAddress == null || receiverAddress == null) {
      return;
    }

    // Send transaction to the relay
    final receiverDelegation = await ref.read(
      userDelegationProvider(details.participantPubkey!).future,
    );
    final currentUserDelegation = await ref.read(currentUserDelegationProvider.future);
    final currentUserPubkey = ref.read(currentPubkeySelectorProvider) ?? '';

    final entityData = WalletAssetData(
      networkId: details.network.id,
      assetClass: sendableAsset.kind,
      assetAddress: coinAssetData.selectedOption!.coin.contractAddress,
      pubkey: details.participantPubkey,
      walletAddress: details.receiverAddress,
      content: WalletAssetContent(
        amount: transferResult.requestBody['amount'] as String?,
        amountUsd: coinAssetData.amountUSD.toString(),
        txHash: details.txHash,
        txUrl: details.transactionExplorerUrl,
        from: senderAddress,
        to: receiverAddress,
      ),
    );

    final senderPubkeys = (
      masterPubkey: currentUserPubkey,
      devicePubkeys: currentUserDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [],
    );
    final receiverPubkeys = (
      masterPubkey: details.participantPubkey!,
      devicePubkeys: receiverDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [],
    );

    final sendToRelayService = await ref.read(sendTransactionToRelayServiceProvider.future);
    final event = await sendToRelayService.sendTransactionEntity(
      createEventMessage: (devicePubkey, masterPubkey) => entityData.toEventMessage(
        devicePubkey: devicePubkey,
        masterPubkey: masterPubkey,
        requestEntity: requestEntity,
      ),
      senderPubkeys: senderPubkeys,
      receiverPubkeys: receiverPubkeys,
    );

    final eventReference = ImmutableEventReference(
      eventId: event.id,
      pubkey: currentUserPubkey,
      kind: event.kind,
    );
    final content = eventReference.encode();
    final tag = eventReference.toTag();

    final chatService = await ref.read(sendChatMessageServiceProvider.future);
    await chatService.send(
      receiverPubkey: details.participantPubkey!,
      content: content,
      tags: [tag],
    );
  }
}
