import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';

import '../mocks.dart';
import '../test_utils.dart';

void main() {
  group('CurrentWalletIdProvider', () {
    test('returns the selected wallet id when it exists in the data', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      final mockNotifier = container.read(selectedWalletIdNotifierProvider.notifier);
      mockNotifier.selectedWalletId = '1';

      final currentWalletId = container.read(currentWalletIdProvider);

      expect(currentWalletId, equals('1'));
    });

    test('returns the first wallet id when selected id does not exist', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      final mockNotifier = container.read(selectedWalletIdNotifierProvider.notifier);

      mockNotifier.selectedWalletId = 'non_existing_id';

      final currentWalletId = container.read(currentWalletIdProvider);

      expect(currentWalletId, equals(mockedWalletDataArray.first.id));
    });

    test('returns an empty string when there are no wallets', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(MockWalletsDataNotifier.new),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      final mockWalletsNotifier = container.read(walletsDataNotifierProvider.notifier);
      final mockSelectedWalletNotifier = container.read(selectedWalletIdNotifierProvider.notifier);

      mockWalletsNotifier.state = [];
      mockSelectedWalletNotifier.selectedWalletId = 'non_existing_id';

      final currentWalletId = container.read(currentWalletIdProvider);

      expect(currentWalletId, equals(''));
    });
  });

  group('currentWalletDataProvider', () {
    test('returns the correct wallet data for the current wallet id', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(MockWalletsDataNotifier.new),
          currentWalletIdProvider.overrideWithValue('1'),
        ],
      );

      final mockWalletsNotifier = container.read(walletsDataNotifierProvider.notifier);

      mockWalletsNotifier.state = mockedWalletDataArray;

      final currentWalletData = container.read(currentWalletDataProvider);

      expect(currentWalletData.id, equals('1'));
      expect(currentWalletData.name, equals('ice.wallet'));
      expect(currentWalletData.balance, equals(36594.33));
    });

    test('throws StateError when the current wallet id does not exist', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(MockWalletsDataNotifier.new),
          currentWalletIdProvider.overrideWithValue('non_existing_id'),
        ],
      );

      final mockWalletsNotifier = container.read(walletsDataNotifierProvider.notifier);

      mockWalletsNotifier.state = mockedWalletDataArray;

      expect(() => container.read(currentWalletDataProvider), throwsStateError);
    });
  });

  group('walletByIdProvider', () {
    test('returns correct wallet data for given id', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );

      final walletData = container.read(walletByIdProvider(id: '1'));

      expect(walletData, isA<WalletData>());
      expect(walletData.id, '1');
    });

    test('throws when wallet with given id does not exist', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );

      expect(() => container.read(walletByIdProvider(id: 'non-existent')), throwsStateError);
    });
  });

  group('WalletsDataNotifier', () {
    test('initial state is mockedWalletDataArray', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final state = container.read(walletsDataNotifierProvider);

      expect(state, equals(mockedWalletDataArray));
    });

    test('addWallet() adds a new wallet', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final notifier = container.read(walletsDataNotifierProvider.notifier);

      final newWallet = WalletData(
        id: '4',
        name: 'New Wallet',
        icon: 'icon',
        balance: 100,
      );

      notifier.addWallet(newWallet);

      expect(notifier.state, contains(newWallet));
    });

    test('updateWallet() updates an existing wallet', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final notifier = container.read(walletsDataNotifierProvider.notifier);

      final updatedWallet = WalletData(
        id: '1',
        name: 'Updated Wallet',
        icon: 'new_icon',
        balance: 200,
      );

      notifier.updateWallet(updatedWallet);

      expect(
        notifier.state.firstWhere((wallet) => wallet.id == '1'),
        equals(updatedWallet),
      );
    });

    test('deleteWallet() removes a wallet', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final notifier = container.read(walletsDataNotifierProvider.notifier);

      notifier.deleteWallet('1');

      expect(notifier.state.any((wallet) => wallet.id == '1'), isFalse);
    });

    test('addWallet() throws exception when wallet with same id already exists', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final notifier = container.read(walletsDataNotifierProvider.notifier);

      final existingWallet = mockedWalletDataArray.first;

      expect(
        () => notifier.addWallet(existingWallet),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Wallet with id ${existingWallet.id} already exists'),
          ),
        ),
      );
    });

    test('updateWallet() throws exception when wallet does not exist', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
        ],
      );
      final notifier = container.read(walletsDataNotifierProvider.notifier);

      final nonExistentWallet = WalletData(
        id: 'non-existent',
        name: 'Non-existent Wallet',
        icon: 'icon',
        balance: 0,
      );

      expect(
        () => notifier.updateWallet(nonExistentWallet),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Wallet with id ${nonExistentWallet.id} does not exist'),
          ),
        ),
      );
    });
  });
}
