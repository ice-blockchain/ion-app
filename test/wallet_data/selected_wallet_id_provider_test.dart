import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../mocks.dart';
import '../test_utils.dart';

const defaultWalletId = '1';

void main() {
  late ProviderContainer container;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    when(() => mockLocalStorage.getString(any())).thenReturn(defaultWalletId);
    when(() => mockLocalStorage.setString(any(), any())).thenAnswer((_) async => true);

    container = createContainer(
      overrides: [
        localStorageProvider.overrideWithValue(mockLocalStorage),
      ],
    );
  });

  test('build returns correct initial value', () {
    final selectedWalletId = container.read(selectedWalletIdNotifierProvider);
    expect(selectedWalletId, equals(defaultWalletId));
  });

  test('updateWalletId updates the state', () {
    final notifier = container.read(selectedWalletIdNotifierProvider.notifier);
    notifier.updateWalletId('2');

    expect(container.read(selectedWalletIdNotifierProvider), equals('2'));
    verify(() => mockLocalStorage.setString(any(), '2')).called(1);
  });
}
