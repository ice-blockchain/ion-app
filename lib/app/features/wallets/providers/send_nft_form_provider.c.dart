// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/data/models/nft_data.c.dart';
import 'package:ion/app/features/wallets/data/models/send_nft_form_data.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/network_fee_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_nft_form_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SendNftFormController extends _$SendNftFormController {
  @override
  SendNftFormData build() {
    listenSelf((previous, next) {
      if (previous?.nft != next.nft) {
        _loadNetworkFeeOptions(next);
      }
    });

    return SendNftFormData(
      arrivalDateTime: DateTime.now().microsecondsSinceEpoch,
      receiverAddress: '',
      nft: null,
    );
  }

  Future<void> setNft(NftData nft) async {
    state = state.copyWith(
      nft: nft,
      senderWallet: null,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
      walletView: await ref.read(currentWalletViewDataProvider.future),
    );
  }

  void setContact(String? pubkey) {
    state = state.copyWith(contactPubkey: pubkey);
    _initReceiverAddressFromContact();
  }

  Future<void> _initReceiverAddressFromContact() async {
    final network = state.nft?.network;
    final pubkey = state.contactPubkey;

    if (pubkey != null && network != null) {
      final contactMetadata = await ref.read(userMetadataProvider(pubkey).future);
      final walletAddress = contactMetadata?.data.wallets?[network.id];

      // Assuming that wallet address shouldn't be null because of the check during selection
      if (walletAddress != null) {
        state = state.copyWith(receiverAddress: walletAddress);
      }
    }
  }

  Future<void> _loadNetworkFeeOptions(SendNftFormData form) async {
    final wallets = await ref.read(walletViewCryptoWalletsProvider().future);
    final wallet = wallets.firstWhereOrNull(
      (wallet) => wallet.network == form.nft?.network.id,
    );

    // Reset current information about network
    state = state.copyWith(
      senderWallet: wallet,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );

    final nft = form.nft;
    if (nft == null || wallet == null) {
      return;
    }

    unawaited(
      _initReceiverAddressFromContact(),
    );

    // Use the networkFee provider to load fee information
    // For NFTs, we'll use the network's native token symbol as the asset symbol
    final networkFeeInfo = await ref.read(
      networkFeeProvider(
        walletId: wallet.id,
        network: nft.network,
      ).future,
    );

    if (networkFeeInfo == null) {
      Logger.error('Cannot load fees info. networkFeeInfo is null.');
      return;
    }

    state = state.copyWith(
      networkFeeOptions: networkFeeInfo.networkFeeOptions,
      selectedNetworkFeeOption: networkFeeInfo.networkFeeOptions.firstOrNull,
      networkNativeToken: networkFeeInfo.networkNativeToken,
    );

    checkIfUserCanCoverFee();
  }

  void checkIfUserCanCoverFee() {
    state = state.copyWith(
      canCoverNetworkFee: canUserCoverFee(
        selectedFee: state.selectedNetworkFeeOption,
        networkNativeToken: state.networkNativeToken,
      ),
    );
  }

  void setReceiverAddress(String address) {
    state = state.copyWith(receiverAddress: address);
  }

  void selectNetworkFeeOption(NetworkFeeOption selectedOption) {
    state = state.copyWith(
      selectedNetworkFeeOption: selectedOption,
    );
    checkIfUserCanCoverFee();
  }
}
