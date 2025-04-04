// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user/model/request_coins_form_data.c.dart';
import 'package:ion/app/features/user/providers/request_coins_form_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/send_transaction_to_relay_service.c.dart';
import 'package:ion/app/features/wallets/model/entities/request_asset_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_coins_submit_notifier.c.g.dart';

typedef _PubkeysRecord = ({
  String masterPubkey,
  List<String> devicePubkeys,
});

typedef _PubkeysCollection = ({
  _PubkeysRecord sender,
  _PubkeysRecord receiver,
});

const _formName = 'RequestCoinsForm';

@Riverpod(keepAlive: true)
class RequestCoinsSubmitNotifier extends _$RequestCoinsSubmitNotifier {
  @override
  Future<void> build() async {}

  Future<void> submitRequest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final formData = ref.read(requestCoinsFormControllerProvider);
      _validateFormData(formData);

      final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentUserPubkey == null) {
        throw const CurrentUserNotFoundException();
      }

      final request = _buildRequestAssetData(formData);
      final pubkeys = await _collectPubkeys(formData.contactPubkey!, currentUserPubkey);

      final sendToRelayService = await ref.read(sendTransactionToRelayServiceProvider.future);
      await sendToRelayService.sendTransactionEntity(
        createEventMessage: (currentUserPubkey) =>
            request.toEventMessage(currentUserPubkey: currentUserPubkey),
        senderPubkeys: pubkeys.sender,
        receiverPubkeys: pubkeys.receiver,
      );
    });
  }

  void _validateFormData(RequestCoinsFormData formData) {
    final errors = <String>[];

    if (formData.assetData == null) {
      errors.add('Asset data is required');
    }
    if (formData.network == null) {
      errors.add('Network is required');
    }
    if (formData.contactPubkey == null) {
      errors.add('Contact pubkey is required');
    }

    final toWalletAddress = formData.toWallet?.address;
    final fromWalletAddress = formData.assetData?.selectedOption?.walletAddress;

    if (toWalletAddress == null) {
      errors.add('toWallet address is required');
    }
    if (fromWalletAddress == null) {
      errors.add('fromWallet address is required');
    }

    final amount = formData.assetData?.amount;
    if (amount != null && amount <= 0) {
      errors.add('Amount must be greater than 0');
    }

    if (errors.isNotEmpty) {
      throw FormException(errors.join(', '), formName: _formName);
    }
  }

  RequestAssetData _buildRequestAssetData(RequestCoinsFormData formData) {
    final RequestCoinsFormData(:assetData, :network, :contactPubkey, :toWallet) = formData;
    final toWalletAddress = toWallet!.address!;
    final fromWalletAddress = assetData!.selectedOption!.walletAddress!;

    final content = RequestAssetContent(
      from: fromWalletAddress,
      to: toWalletAddress,
      assetId: assetData.selectedOption!.coin.id,
      amount: assetData.amount > 0 ? assetData.amount.toString() : null,
      amountUsd: assetData.amountUSD > 0 ? assetData.amountUSD.toString() : null,
    );

    final contractAddress = assetData.selectedOption!.coin.contractAddress;
    final isNative = contractAddress.isEmpty;

    return RequestAssetData(
      networkId: network!.id,
      assetClass: isNative ? 'native' : 'token',
      assetAddress: contractAddress,
      pubkey: contactPubkey,
      walletAddress: toWalletAddress,
      content: content,
    );
  }

  Future<_PubkeysCollection> _collectPubkeys(String contactPubkey, String currentUserPubkey) async {
    final currentUserDelegation = await ref.read(currentUserDelegationProvider.future);
    final contactDelegation = await ref.read(userDelegationProvider(contactPubkey).future);

    final senderDevicePubkeys =
        currentUserDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [];
    final receiverDevicePubkeys =
        contactDelegation?.data.delegates.map((e) => e.pubkey).toList() ?? [];

    if (senderDevicePubkeys.isEmpty && receiverDevicePubkeys.isEmpty) {
      throw FormException(
        'No device pubkeys found for either sender or receiver',
        formName: _formName,
      );
    }

    return (
      sender: (
        masterPubkey: currentUserPubkey,
        devicePubkeys: senderDevicePubkeys,
      ),
      receiver: (
        masterPubkey: contactPubkey,
        devicePubkeys: receiverDevicePubkeys,
      ),
    );
  }
}
