import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/domain/wallets_repository.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@riverpod
class WalletsRepositoryNotifier extends _$WalletsRepositoryNotifier {
  @override
  List<WalletData> build() => ref.watch(walletRepositoryProvider).wallets;

  void updateWallet(WalletData newWallet) {
    final repository = ref.read(walletRepositoryProvider);
    repository.updateWallet(newWallet);
    state = [...repository.wallets];
  }

  void deleteWallet(String id) {
    final repository = ref.read(walletRepositoryProvider);
    repository.deleteWallet(id);
    state = [...repository.wallets];
  }

  void addWallet(WalletData newWallet) {
    final repository = ref.read(walletRepositoryProvider);
    repository.addWallet(newWallet);
    state = [...repository.wallets];
  }

  void setCurrentWalletId(String id) {
    final repository = ref.read(walletRepositoryProvider);
    repository.currentWalletId = id;
    state = [...repository.wallets];
  }
}

@riverpod
WalletData currentWallet(CurrentWalletRef ref) {
  final wallets = ref.watch(walletsRepositoryNotifierProvider);
  final currentWalletId = ref.watch(walletRepositoryProvider).currentWalletId;
  return wallets.firstWhere(
    (wallet) => wallet.id == currentWalletId,
    orElse: () => wallets.first,
  );
}

@riverpod
WalletsRepository walletRepository(WalletRepositoryRef ref) =>
    WalletsRepository(ref.watch(localStorageProvider));
