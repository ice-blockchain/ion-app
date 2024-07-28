import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/data/wallets_repository.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';

void main() {
  late WalletsRepository repository;

  setUp(() {
    repository = WalletsRepository(mockedWalletDataArray);
  });

  group('WalletRepository Tests', () {
    test('initial wallets are loaded correctly', () {
      expect(repository.wallets, isNotEmpty);
      expect(repository.wallets.length, equals(mockedWalletDataArray.length));
    });

    test('updateWallet() updates existing wallet', () {
      final updatedWallet = WalletData(
        id: '1',
        name: 'Updated Wallet',
        icon: 'new_icon',
        balance: 100.0,
      );
      repository.updateWallet(updatedWallet);

      expect(
        repository.wallets.any(
          (wallet) => wallet.id == '1' && wallet.name == 'Updated Wallet',
        ),
        isTrue,
      );
    });

    test('deleteWallet() removes wallet', () {
      final initialLength = repository.wallets.length;
      repository.deleteWallet('2');

      expect(repository.wallets.any((wallet) => wallet.id == '2'), isFalse);
      expect(repository.wallets.length, equals(initialLength - 1));
    });

    test('addWallet() adds new wallet', () {
      final initialLength = repository.wallets.length;
      final newWallet = WalletData(
        id: '4',
        name: 'New Wallet',
        icon: 'new_icon',
        balance: 0.0,
      );
      repository.addWallet(newWallet);

      expect(repository.wallets.any((wallet) => wallet.id == '4'), isTrue);
      expect(repository.wallets.length, equals(initialLength + 1));
    });
  });
}
