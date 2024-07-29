import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/utils/in_memory_store.dart';

class WalletsRepository {
  final InMemoryStore<List<WalletData>> _walletsStore;

  WalletsRepository(List<WalletData> wallets)
      : _walletsStore = InMemoryStore<List<WalletData>>(wallets);

  Stream<List<WalletData>> get walletsStream => _walletsStore.stream;

  List<WalletData> get wallets => List.unmodifiable(_walletsStore.value);

  void updateWallet(WalletData newWallet) {
    final index = _walletsStore.value.indexWhere((wallet) => wallet.id == newWallet.id);
    if (index != -1) {
      final updatedWallets = [..._walletsStore.value];
      updatedWallets[index] = newWallet;
      _walletsStore.value = updatedWallets;
    }
  }

  void deleteWallet(String id) {
    final wallets = [..._walletsStore.value];
    wallets.removeWhere((wallet) => wallet.id == id);
    _walletsStore.value = wallets;
  }

  void addWallet(WalletData newWallet) {
    if (!_walletsStore.value.any((wallet) => wallet.id == newWallet.id)) {
      _walletsStore.value = [..._walletsStore.value, newWallet];
    }
  }

  void close() => _walletsStore.close();
}
