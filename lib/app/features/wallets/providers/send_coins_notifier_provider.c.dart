// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_relays.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/transfer_result.c.dart';
import 'package:ion/app/features/wallets/model/transfer_status.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
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
    final form = ref.read(sendAssetFormControllerProvider());

    if (form.assetData is! CoinAssetData) {
      Logger.error('Cannot send coins: asset data is not a coin asset');
      return;
    }

    final coinAssetData = form.assetData as CoinAssetData;
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
      final service = await ref.read(coinsServiceProvider.future);

      final result = await service.send(
        amount: coinAssetData.amount,
        senderWallet: senderWallet,
        sendableAsset: sendableAsset,
        onVerifyIdentity: onVerifyIdentity,
        receiverAddress: form.receiverAddress,
      );

      if (result.status == TransferStatus.failed || result.status == TransferStatus.rejected) {
        throw FailedToSendCryptoAssetsException(result.reason);
      }

      Logger.info('Transaction was successful. Hash: ${result.txHash}');

      final details = TransactionDetails(
        txHash: result.txHash!,
        walletId: result.walletId,
        network: form.network!,
        status: result.status,
        dateRequested: result.dateRequested,
        dateConfirmed: result.dateConfirmed,
        dateBroadcasted: result.dateBroadcasted,
        assetData: coinAssetData,
        walletViewName: form.wallet.name,
        senderAddress: form.senderWallet!.address!,
        receiverAddress: form.receiverAddress,
        receiverPubkey: form.contactPubkey,
        type: TransactionType.send,
        networkFeeOption: form.selectedNetworkFeeOption,
      );

      await _sendTransactionEntity(
        details: details,
        transferResult: result,
        sendableAsset: sendableAsset,
        coinAssetData: coinAssetData,
      );

      return details;
    });
  }

  Future<void> _sendTransactionEntity({
    required TransactionDetails details,
    required TransferResult transferResult,
    required WalletAsset sendableAsset,
    required CoinAssetData coinAssetData,
  }) async {
    final walletAssetContent = WalletAssetContent(
      amount: transferResult.requestBody['amount'] as String?,
      amountUsd: coinAssetData.priceUSD.toString(),
      balance: sendableAsset.balance, // number of coins before transfer
      txUrl: details.transactionExplorerUrl,
      from: details.senderAddress,
      to: details.receiverAddress,
    );
    final e2eeService = await ref.read(ionConnectE2eeServiceProvider.future);
    final encoded = await e2eeService.encryptMessage(jsonEncode(walletAssetContent));
    await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([
      WalletAssetData(
        content: encoded,
        networkId: details.network.id,
        assetClass: '', // ???
        // contract address ?? coinAssetData.selectedOption!.coin.contractAddress;
        assetAddress: '',
        // TODO: Need to discuss. It can be null, if user sends money not to contact, but by the wallet address directly
        pubkey: details.receiverPubkey!,
      ),
    ]);
  }
}
