// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.c.g.dart';

enum CryptoAssetType { coin, nft }

@riverpod
class SendAssetFormController extends _$SendAssetFormController {
  // TODO: make async
  @override
  CryptoAssetData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final wallet = ref.watch(currentWalletViewDataProvider).valueOrNull;

    return CryptoAssetData(
      selectedNetwork: NetworkType.eth,
      wallet: wallet!,
      address: 'Not implemented', // TODO (1) not implemented
      arrivalTime: 15,
      arrivalDateTime: DateTime.now(),
    );
  }

  void setNft(NftData nft) => state = state.copyWith(selectedNft: nft);

  void setCoin(CoinInWalletData coin) => state = state.copyWith(selectedCoin: coin);

  void setContact(String? pubkey) => state = state.copyWith(selectedContactPubkey: pubkey);

  void setNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);

  void updateAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    state = state.copyWith(
      selectedCoin: state.selectedCoin?.copyWith(
        amount: value,
      ),
    );
  }

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);
}
