// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
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

      Logger.info('Transaction was successful. Hash: ${result.txHash}');

      return TransactionDetails(
        txHash: result.txHash,
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
    });
  }
}
