import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/domain/wallets_repository.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late WalletsRepository repository;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    repository = WalletsRepository(mockLocalStorage);
  });

  group('WalletRepository Tests', () {
    test('initial wallets are loaded correctly', () {
      expect(repository.wallets, isNotEmpty);
      expect(repository.wallets.length, equals(mockedWalletDataArray.length));
    });

    test('updateWallet updates existing wallet', () {
      repository.updateWallet(
        WalletData(
          id: '1',
          name: 'Updated Wallet',
          icon: 'new_icon',
          balance: 100.0,
        ),
      );

      expect(
          repository.wallets.any(
            (wallet) => wallet.id == '1' && wallet.name == 'Updated Wallet',
          ),
          isTrue);
    });

    test('deleteWallet removes wallet', () {
      repository.deleteWallet('2');

      expect(repository.wallets.any((wallet) => wallet.id == '2'), isFalse);
    });

    test('addWallet adds new wallet', () {
      repository.addWallet(
        WalletData(
          id: '4',
          name: 'New Wallet',
          icon: 'new_icon',
          balance: 0.0,
        ),
      );

      expect(repository.wallets.any((wallet) => wallet.id == '4'), isTrue);
    });

    test('currentWalletId gets and sets correctly', () {
      when(() => mockLocalStorage.getString(any())).thenReturn('2');
      when(() => mockLocalStorage.setString(any(), any())).thenAnswer((_) async => true);

      expect(repository.currentWalletId, equals('2'));

      repository.currentWalletId = '3';
      verify(() => mockLocalStorage.setString(any(), '3')).called(1);
    });
  });
}
