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
  // TODO: make async
  @override
  CryptoAssetData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final wallet = ref.watch(currentWalletDataProvider).valueOrNull;

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
    state = state.copyWith(
      selectedCoin: state.selectedCoin?.copyWith(
        amount: value,
      ),
    );
  }

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);
}
