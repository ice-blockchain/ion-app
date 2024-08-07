import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../mocks.dart';
import '../test_utils.dart';

void main() {
  late ProviderContainer container;
  late MockLocalStorage mockLocalStorage;

  setUp(
    () {
      mockLocalStorage = MockLocalStorage();
      container = createContainer(
        overrides: [
          localStorageProvider.overrideWithValue(mockLocalStorage),
        ],
      );
    },
  );

  group('SelectedWalletIdNotifier Tests', () {
    test('build returns value from localStorage if it exists', () {
      when(
        () => mockLocalStorage.getString(
          SelectedWalletIdNotifier.selectedWalletIdKey,
        ),
      ).thenReturn('testWalletId');

      final result = container.read(selectedWalletIdNotifierProvider);

      expect(result, 'testWalletId');

      verify(
        () => mockLocalStorage.getString(SelectedWalletIdNotifier.selectedWalletIdKey),
      ).called(1);
    });

    test('build() returns first mocked wallet id if localStorage is empty', () {
      when(
        () => mockLocalStorage.getString(SelectedWalletIdNotifier.selectedWalletIdKey),
      ).thenReturn(null);

      final result = container.read(selectedWalletIdNotifierProvider);

      expect(result, mockedWalletDataArray[0].id);

      verify(
        () => mockLocalStorage.getString(SelectedWalletIdNotifier.selectedWalletIdKey),
      ).called(1);
    });

    test('selectedWalletId setter updates state and localStorage', () {
      final notifier = container.read(selectedWalletIdNotifierProvider.notifier);

      when(
        () => mockLocalStorage.setString(any(), any()),
      ).thenReturn(null);

      notifier.selectedWalletId = 'newWalletId';

      expect(
        container.read(selectedWalletIdNotifierProvider),
        'newWalletId',
      );

      verify(() => mockLocalStorage.setString(
          SelectedWalletIdNotifier.selectedWalletIdKey, 'newWalletId')).called(1);
    });

    test('notifier reacts to changes in localStorage', () {
      final listener = Listener<String?>();

      when(
        () => mockLocalStorage.getString(SelectedWalletIdNotifier.selectedWalletIdKey),
      ).thenReturn(
        mockedWalletDataArray.first.id,
      );

      container.listen<String?>(
        selectedWalletIdNotifierProvider,
        listener,
        fireImmediately: true,
      );

      verify(
        () => listener(null, mockedWalletDataArray.first.id),
      ).called(1);

      when(
        () => mockLocalStorage.getString(SelectedWalletIdNotifier.selectedWalletIdKey),
      ).thenReturn('updatedWalletId');

      container.refresh(selectedWalletIdNotifierProvider);

      verify(
        () => listener(mockedWalletDataArray.first.id, 'updatedWalletId'),
      ).called(1);
    });
  });
}
