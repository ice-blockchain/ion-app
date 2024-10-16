// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../mocks.dart';
import '../test_utils.dart';

void main() {
  group('CurrentWalletIdProvider', () {
    MockWalletsDataNotifier mockWalletsDataNotifier() =>
        MockWalletsDataNotifier(mockedWalletDataArray);

    test('returns the selected wallet id when it exists in the data', () async {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(mockWalletsDataNotifier),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      container.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId = '1';

      final currentWalletId = await container.read(currentWalletIdProvider.future);

      expect(currentWalletId, equals('1'));
    });

    test('returns the first wallet id when selected id does not exist', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(WalletsDataNotifier.new),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      container.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId =
          'non_existing_id';

      final currentWalletId = container.read(currentWalletIdProvider);

      expect(currentWalletId, equals(mockedWalletDataArray.first.id));
    });

    test('returns an empty string when there are no wallets', () {
      final container = createContainer(
        overrides: [
          walletsDataNotifierProvider.overrideWith(mockWalletsDataNotifier),
          selectedWalletIdNotifierProvider.overrideWith(MockSelectedWalletIdNotifier.new),
        ],
      );

      final mockWalletsNotifier = container.read(walletsDataNotifierProvider.notifier);
      final mockSelectedWalletNotifier = container.read(selectedWalletIdNotifierProvider.notifier);

      mockWalletsNotifier.state = const AsyncValue.data([]);
      mockSelectedWalletNotifier.selectedWalletId = 'non_existing_id';

      final currentWalletId = container.read(currentWalletIdProvider);

      expect(currentWalletId, equals(''));
    });
  });
}
