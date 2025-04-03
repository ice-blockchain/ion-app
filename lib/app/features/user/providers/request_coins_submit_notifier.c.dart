// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user/providers/request_coins_form_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/send_transaction_to_relay_service.c.dart';
import 'package:ion/app/features/wallets/model/entities/request_asset_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_coins_submit_notifier.c.g.dart';

@Riverpod(keepAlive: true)
class RequestCoinsSubmitNotifier extends _$RequestCoinsSubmitNotifier {
  @override
  Future<void> build() async {}

  Future<void> submitRequest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final formData = ref.read(requestCoinsFormControllerProvider);

      if (formData.assetData == null ||
          formData.network == null ||
          formData.contactPubkey == null) {
        throw FormException('Missing required form data', formName: 'RequestCoinsForm');
      }

      final assetData = formData.assetData!;
      final network = formData.network!;
      final contactPubkey = formData.contactPubkey!;

      final walletAddress = assetData.selectedOption?.walletAddress ?? '';

      final content = RequestAssetContent(
        from: walletAddress,
        to: formData.senderWallet?.address ?? '',
        assetId: assetData.selectedOption?.coin.id,
        amount: assetData.amount.toString(),
        amountUsd: assetData.amountUSD.toString(),
      );

      final contractAddress = assetData.selectedOption?.coin.contractAddress ?? '';
      final isNative = contractAddress.isEmpty;

      final request = RequestAssetData(
        networkId: network.id,
        assetClass: isNative ? 'native' : 'token',
        assetAddress: contractAddress,
        pubkey: contactPubkey,
        walletAddress: formData.senderWallet?.address ?? '',
        content: content,
      );

      final currentUserPubkey = ref.read(currentPubkeySelectorProvider) ?? '';

      final currentUserDelegation = await ref.read(currentUserDelegationProvider.future);
      final contactDelegation = await ref.read(userDelegationProvider(contactPubkey).future);

      final senderPubkeys = (
        masterPubkey: currentUserPubkey,
        devicePubkeys: currentUserDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [],
      );

      final receiverPubkeys = (
        masterPubkey: contactPubkey,
        devicePubkeys: contactDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [],
      );

      final sendToRelayService = await ref.read(sendTransactionToRelayServiceProvider.future);
      await sendToRelayService.sendTransactionEntity(
        createEventMessage: (currentUserPubkey) =>
            request.toEventMessage(currentUserPubkey: currentUserPubkey),
        senderPubkeys: senderPubkeys,
        receiverPubkeys: receiverPubkeys,
      );
    });
  }
}
