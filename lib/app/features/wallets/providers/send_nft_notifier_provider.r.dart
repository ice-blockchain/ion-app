// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.r.dart';
import 'package:ion/app/features/wallets/domain/nfts/send_nft_use_case.r.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_details.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/providers/send_nft_form_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_nft_notifier_provider.r.g.dart';

@riverpod
class SendNftNotifier extends _$SendNftNotifier {
  @override
  Future<TransactionDetails?> build() async {
    return null;
  }

  Future<void> send(OnVerifyIdentity<Map<String, dynamic>> onVerifyIdentity) async {
    final form = ref.read(sendNftFormControllerProvider);

    if (form.nft == null) {
      Logger.error('Cannot send nft: nft is missing');
      return;
    }

    final nft = form.nft!;
    final senderWallet = form.senderWallet;

    if (senderWallet == null) {
      Logger.error('Cannot send nft: senderWallet is missing');
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final walletViewId = await ref.read(currentWalletViewIdProvider.future);
      final sendNftUseCase = await ref.read(sendNftUseCaseProvider.future);

      final result = await sendNftUseCase.send(
        senderWallet: senderWallet,
        sendableAsset: nft,
        receiverAddress: form.receiverAddress,
        networkFeeType: form.selectedNetworkFeeOption?.type,
        onVerifyIdentity: onVerifyIdentity,
      );

      if (result.status == TransactionStatus.failed ||
          result.status == TransactionStatus.rejected) {
        throw FailedToSendCryptoAssetsException(result.reason);
      }

      Logger.info('Transaction was successful. Hash: ${result.txHash}');
      final nativeCoin = await ref
          .read(coinsServiceProvider.future)
          .then((service) => service.getNativeCoin(nft.network));

      final details = TransactionDetails(
        id: result.id,
        txHash: result.txHash!,
        walletViewId: walletViewId,
        network: nft.network,
        status: result.status,
        nativeCoin: nativeCoin,
        dateRequested: result.dateRequested,
        dateConfirmed: result.dateConfirmed,
        dateBroadcasted: result.dateBroadcasted,
        assetData: CryptoAssetToSendData.nft(nft: nft),
        walletViewName: form.walletView!.name,
        senderAddress: form.senderWallet!.address,
        receiverAddress: form.receiverAddress,
        participantPubkey: form.contactPubkey,
        type: TransactionType.send,
        networkFeeOption: form.selectedNetworkFeeOption,
      );

      // Save NFT transaction to database
      try {
        final transactionsRepository = await ref.read(transactionsRepositoryProvider.future);

        // Enhanced logging for NFT transaction saving
        final nftId = details.assetData.when(
          coin: (_, __, ___, ____, _____, ______) => 'N/A',
          nft: (nft) => '${nft.contract}_${nft.tokenId}',
          notInitialized: () => 'NOT_INITIALIZED',
        );

        Logger.info(
          '[NFT_SEND_DEBUG] Saving NFT transaction | '
          'TxHash: ${details.txHash} | '
          'NFT_ID: $nftId | '
          'WalletViewId: ${details.walletViewId} | '
          'Status: ${details.status} | '
          'Type: ${details.type} | '
          'SenderAddress: ${details.senderAddress} | '
          'ReceiverAddress: ${details.receiverAddress}',
        );

        await transactionsRepository.saveTransactionDetails(details);
        Logger.info('[NFT_SEND_DEBUG] ✅ NFT transaction saved successfully: ${details.txHash}');
      } catch (error) {
        Logger.error('[NFT_SEND_DEBUG] ❌ Failed to save NFT transaction: $error');
      }

      return details;
    });
  }
}
