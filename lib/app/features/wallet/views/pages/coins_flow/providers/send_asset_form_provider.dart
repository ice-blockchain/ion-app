import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/crypto_asset_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.g.dart';

enum CryptoAssetType { coin, nft }

@riverpod
class SendAssetFormController extends _$SendAssetFormController {
  late final CryptoAssetType _cryptoType;

  @override
  CryptoAssetData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final wallet = ref.watch(currentWalletDataProvider);
    _cryptoType = type;

    return CryptoAssetData(
      selectedCoin: null,
      selectedNft: null,
      selectedNetwork: NetworkType.eth,
      wallet: wallet,
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
      usdtAmount: 350,
      arrivalTime: 15,
      selectedContact: null,
    );
  }

  void setNft(NftData nft) => state = state.copyWith(selectedNft: nft);

  void setCoin(CoinData coin) => state = state.copyWith(selectedCoin: coin);

  void setContact(ContactData? contact) => state = state.copyWith(selectedContact: contact);

  void setNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);

  void updateAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    state = state.copyWith(usdtAmount: value);
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

  double getUsdtAmount() => state.usdtAmount ?? 0.0;
}
