// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/model/contact_data.c.dart';
import 'package:ion/app/features/wallet/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallet/model/wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.c.g.dart';

enum CryptoAssetType { coin, nft }

@riverpod
class SendAssetFormController extends _$SendAssetFormController {
  late final CryptoAssetType _cryptoType;

  // TODO: make async
  @override
  CryptoAssetData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final wallet = ref.watch(currentWalletDataProvider).valueOrNull;
    _cryptoType = type;

    return CryptoAssetData(
      selectedNetwork: NetworkType.eth,
      wallet: wallet ??
          const WalletData(
            id: '1',
            name: 'Wallet 1',
            balance: 0,
            icon: '',
            address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
          ),
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
      amount: 350,
      arrivalTime: 15,
      arrivalDateTime: DateTime.now(),
    );
  }

  void setNft(NftData nft) => state = state.copyWith(selectedNft: nft);

  void setCoin(CoinData coin) => state = state.copyWith(selectedCoin: coin);

  void setContact(ContactData? contact) => state = state.copyWith(selectedContact: contact);

  void setNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);

  void updateAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    state = state.copyWith(amount: value);
  }

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);

  String getAsset() {
    return switch (_cryptoType) {
      CryptoAssetType.coin when state.selectedCoin != null => state.selectedCoin!.asset,
      CryptoAssetType.nft when state.selectedNft != null => state.selectedNft!.asset,
      CryptoAssetType.coin || CryptoAssetType.nft => '',
    };
  }

  String getNetwork() {
    return switch (_cryptoType) {
      CryptoAssetType.coin when state.selectedCoin != null => state.selectedCoin!.network,
      CryptoAssetType.nft when state.selectedNft != null => state.selectedNft!.network,
      CryptoAssetType.coin || CryptoAssetType.nft => '',
    };
  }

  double getAmount() => state.amount ?? 0.0;
}
