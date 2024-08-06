import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@riverpod
String currentWalletId(CurrentWalletIdRef ref) {
  final selectedWalletId = ref.watch(selectedWalletIdNotifierProvider);
  final walletsData = ref.watch(walletsDataNotifierProvider);

  if (walletsData.any((wallet) => wallet.id == selectedWalletId)) {
    return selectedWalletId!;
  }

  return walletsData.isNotEmpty ? walletsData.first.id : '';
}

@riverpod
WalletData currentWalletData(CurrentWalletDataRef ref) {
  final currentWalletId = ref.watch(currentWalletIdProvider);
  final walletsData = ref.watch(walletsDataNotifierProvider);

  return walletsData.firstWhere((wallet) => wallet.id == currentWalletId);
}

@riverpod
WalletData walletById(WalletByIdRef ref, {required String id}) {
  final wallets = ref.read(walletsDataNotifierProvider);

  return wallets.firstWhere((wallet) => wallet.id == id);
}

@Riverpod(keepAlive: true)
class WalletsDataNotifier extends _$WalletsDataNotifier {
  @override
  List<WalletData> build() {
    return List.from(mockedWalletDataArray);
  }

  void addWallet(WalletData newData) {
    if (state.any((wallet) => wallet.id == newData.id)) {
      throw Exception('Wallet with id ${newData.id} already exists');
    }

    state = [...state, newData];
  }

  void updateWallet(WalletData updatedData) {
    final walletExists = state.any((wallet) => wallet.id == updatedData.id);

    if (!walletExists) {
      throw Exception('Wallet with id ${updatedData.id} does not exist');
    }

    state = state.map((wallet) {
      return wallet.id == updatedData.id ? updatedData : wallet;
    }).toList();
  }

  void deleteWallet(String walletId) {
    state = state.where((wallet) => wallet.id != walletId).toList();
  }
}

class MockWalletsDataNotifier extends _$WalletsDataNotifier
    with Mock
    implements WalletsDataNotifier {}
