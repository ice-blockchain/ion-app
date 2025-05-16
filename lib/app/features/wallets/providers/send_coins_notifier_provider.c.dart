// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message_service.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/send_transaction_to_relay_service.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/transfer_result.c.dart';
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
  @override
  Future<TransactionDetails?> build() async {
    state = const AsyncData(null);
    return null;
  }

  Future<void> send(OnVerifyIdentity<Map<String, dynamic>> onVerifyIdentity) async {
    if (state.isLoading) return;

    final form = ref.read(sendAssetFormControllerProvider);

    if (form.assetData is! CoinAssetToSendData) {
      Logger.error('Cannot send coins: asset data is not a coin asset');
      return;
    }

    final coinAssetData = form.assetData as CoinAssetToSendData;
    final sendableAsset = coinAssetData.associatedAssetWithSelectedOption;
    final senderWallet = form.senderWallet;

    if (senderWallet == null || sendableAsset == null) {
      final missingComponent = senderWallet == null ? 'senderWallet' : 'sendableAsset';
      Logger.error(
        'Cannot send coins: $missingComponent is missing',
      );
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final walletViewId = await ref.read(currentWalletViewIdProvider.future);
      final service = await ref.read(coinsServiceProvider.future);

      var result = await service.send(
        amount: coinAssetData.amount,
        senderWallet: senderWallet,
        sendableAsset: sendableAsset,
        onVerifyIdentity: onVerifyIdentity,
        receiverAddress: form.receiverAddress,
      );

      bool isRetryStatus(TransactionStatus status) =>
          status == TransactionStatus.pending || status == TransactionStatus.executing;
      if (isRetryStatus(result.status)) {
        // When executing or pending, txHash is still null, so we need to wait a bit
        result = await withRetry<TransferResult>(
          ({Object? error}) => service.getTransfer(
            walletId: senderWallet.id,
            transferId: result.id,
          ),
          maxRetries: 5,
          initialDelay: const Duration(seconds: 1),
          retryWhen: (result) => result is TransferResult && isRetryStatus(result.status),
        );
      }

      if (result.status == TransactionStatus.rejected ||
          result.status == TransactionStatus.failed) {
        throw FailedToSendCryptoAssetsException(result.reason);
      }

      Logger.info('Transaction was successful. Hash: ${result.txHash}');

      final nativeCoin = await ref.read(coinsRepositoryProvider).getNativeCoin(form.network!);

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

      return details;
    });

    unawaited(
      ref.read(syncedCoinsBySymbolGroupNotifierProvider.notifier).refresh(
        [coinAssetData.coinsGroup.symbolGroup],
      ),
    );

    if (state.hasError) {
      // Log to get the error stack trace
      Logger.error(state.error!, stackTrace: state.stackTrace);
    }
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
      createEventMessage: (currentUserPubkey) => entityData.toEventMessage(
        currentUserPubkey: currentUserPubkey,
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
