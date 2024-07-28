import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/data/in_memory_store.dart';

class WalletsRepository {
  final InMemoryStore<List<WalletData>> _walletsStore;

  WalletsRepository(List<WalletData> wallets)
      : _walletsStore = InMemoryStore<List<WalletData>>(wallets);

  Stream<List<WalletData>> get walletsStream => _walletsStore.stream;

  List<WalletData> get wallets => List.unmodifiable(_walletsStore.value);

  void updateWallet(WalletData newWallet) {
    final wallets = [..._walletsStore.value];
    final index = wallets.indexWhere((wallet) => wallet.id == newWallet.id);
    if (index != -1) {
      wallets[index] = wallets[index].copyWith(
        name: newWallet.name,
        icon: newWallet.icon,
        balance: newWallet.balance,
      );
      _walletsStore.value = wallets;
    }
  }

  void deleteWallet(String id) {
    final wallets = [..._walletsStore.value];
    wallets.removeWhere((wallet) => wallet.id == id);
    _walletsStore.value = wallets;
  }

  void addWallet(WalletData newWallet) {
    final wallets = [..._walletsStore.value];
    if (!wallets.any((wallet) => wallet.id == newWallet.id)) {
      wallets.add(newWallet);
      _walletsStore.value = wallets;
    }
  }

  void close() => _walletsStore.close();
}
