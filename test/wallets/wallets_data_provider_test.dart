// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallet/model/wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_id_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';

import '../mocks.dart';
import '../test_utils.dart';

void main() {
  group('CurrentWalletIdProvider', () {
    test('returns the selected wallet id when it exists in the data', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      container.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId = '1';

      final currentWalletId = await container.read(currentWalletIdProvider.future);

      expect(currentWalletId, equals('1'));
    });

    test('returns the first wallet id when selected id does not exist', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      container.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId =
          'non_existing_id';

      final currentWalletId = await container.read(currentWalletIdProvider.future);

      expect(currentWalletId, equals(mockedWalletDataArray.first.id));
    });

    test('returns an empty string when there are no wallets', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier([]),
          ),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      container.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId =
          'non_existing_id';

      final currentWalletId = await container.read(currentWalletIdProvider.future);

      expect(currentWalletId, equals(''));
    });
  });

  group('currentWalletDataProvider', () {
    test('returns the correct wallet data for the current wallet id', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
          currentWalletIdProvider.overrideWith((ref) => '1'),
        ],
      );

      final currentWalletData = await container.read(currentWalletDataProvider.future);

      expect(currentWalletData.id, equals('1'));
      expect(currentWalletData.name, equals('ice.wallet'));
      expect(currentWalletData.balance, equals(36594.33));
    });

    test('throws StateError when the current wallet id does not exist', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
          currentWalletIdProvider.overrideWith((ref) => 'non_existing_id'),
        ],
      );

      try {
        await container.read(currentWalletDataProvider.future);
        fail('Expected StateError to be thrown');
      } catch (e) {
        expect(e, isA<StateError>());
      }
    });
  });

  group('walletByIdProvider', () {
    test('returns correct wallet data for given id', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
        ],
      );

      final result = await container.read(walletByIdProvider(id: '1').future);

      expect(result, isA<WalletData>());
      expect(result.id, '1');
    });

    test('throws when wallet with given id does not exist', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(
            () => MockWalletsDataNotifier(mockedWalletDataArray),
          ),
        ],
      );

      try {
        await container.read(walletByIdProvider(id: 'non-existent').future);
        fail('Expected StateError to be thrown');
      } catch (e) {
        expect(e, isA<StateError>());
      }
    });
  });
}
