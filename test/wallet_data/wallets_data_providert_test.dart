import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../mocks.dart';
import '../test_utils.dart';

const defaultWalletId = '1';
const nonExistentWalletId = '5';

final testWallets = [
  WalletData(id: '1', name: 'ice.wallet', icon: '', balance: 0),
  WalletData(id: '2', name: 'Airdrop wallet', icon: '', balance: 0),
  WalletData(id: '3', name: 'For transfers', icon: '', balance: 0),
];

void main() {
  late MockWalletRepository mockRepository;
  late MockLocalStorage mockLocalStorage;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockWalletRepository();
    mockLocalStorage = MockLocalStorage();

    when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
    when(() => mockRepository.wallets).thenReturn(testWallets);
    when(() => mockLocalStorage.getString(any())).thenReturn(defaultWalletId);
    when(() => mockLocalStorage.setString(any(), any())).thenAnswer((_) async => true);

    container = createContainer(
      overrides: [
        walletsRepositoryProvider.overrideWithValue(mockRepository),
        localStorageProvider.overrideWithValue(mockLocalStorage),
      ],
    );
  });

  group('SelectedWalletIdNotifier', () {
    test('build returns correct initial value', () async {
      final selectedWalletId = container.read(selectedWalletIdNotifierProvider);
      expect(selectedWalletId, equals(defaultWalletId));
    });

    test('updateWalletId updates the state', () async {
      final notifier = container.read(selectedWalletIdNotifierProvider.notifier);
      notifier.updateWalletId('2');

      // Проверяем, что значение обновилось
      expect(container.read(selectedWalletIdNotifierProvider), equals('2'));

      // Проверяем, что значение было сохранено в localStorage
      verify(() => mockLocalStorage.setString(any(), '2')).called(1);
    });
  });

  group('currentWallet', () {
    test('returns correct wallet', () async {
      final currentWallet = container.read(currentWalletProvider);
      expect(currentWallet, equals(testWallets[0]));
    });

    test('updates when selected wallet id changes', () async {
      final listener = Listener<WalletData>();
      container.listen(currentWalletProvider, listener, fireImmediately: true);

      container.read(selectedWalletIdNotifierProvider.notifier).updateWalletId('2');
      await pumpEventQueue();

      verifyInOrder([
        () => listener(null, testWallets[0]),
        () => listener(testWallets[0], testWallets[1]),
      ]);
    });
  });

  group('wallets', () {
    test('initial state is correct', () async {
      final wallets = container.read(walletsProvider);
      expect(wallets, equals(testWallets));
    });

    test('updates when repository stream emits', () async {
      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      final updatedWallets = [
        WalletData(id: '1', name: 'Updated Wallet', icon: '', balance: 100),
        ...testWallets.sublist(1),
      ];
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(updatedWallets));

      // Simulate repository update
      container.refresh(walletsRepositoryProvider);
      await pumpEventQueue();

      verifyInOrder([
        () => listener(null, testWallets),
        () => listener(testWallets, updatedWallets),
      ]);
    });
  });
}
