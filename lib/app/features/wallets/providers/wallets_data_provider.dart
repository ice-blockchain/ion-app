import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/repository/wallets_repository.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@riverpod
WalletData currentWallet(CurrentWalletRef ref) {
  final wallets = ref.watch(walletsRepositoryProvider).wallets;
  final currentWalletId = ref.watch(selectedWalletIdNotifierProvider);

  return wallets.firstWhere(
    (wallet) => wallet.id == currentWalletId,
    orElse: () => wallets.first,
  );
}

@riverpod
List<WalletData> wallets(WalletsRef ref) {
  final repository = ref.watch(walletsRepositoryProvider);
  final stream = repository.walletsStream;

  List<WalletData> updatedWallets = repository.wallets;

  stream.listen((wallets) {
    updatedWallets = wallets;
    ref.state = updatedWallets;
  });

  return updatedWallets;
}

@Riverpod(keepAlive: true)
WalletsRepository walletsRepository(WalletsRepositoryRef ref) {
  final walletRepository = WalletsRepository(mockedWalletDataArray);

  ref.onDispose(() => walletRepository.close());

  return walletRepository;
}
