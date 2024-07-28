import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../mocks.dart';
import '../test_utils.dart';

final testWallets = [
  WalletData(id: '1', name: 'ice.wallet', icon: '', balance: 0),
  WalletData(id: '2', name: 'Airdrop wallet', icon: '', balance: 0),
  WalletData(id: '3', name: 'For transfers', icon: '', balance: 0),
];

void main() {
  late MockWalletRepository mockRepository;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockRepository = MockWalletRepository();
    mockLocalStorage = MockLocalStorage();
  });

  ProviderContainer createTestContainer() {
    return createContainer(
      overrides: [
        walletsRepositoryProvider.overrideWithValue(mockRepository),
        localStorageProvider.overrideWithValue(mockLocalStorage),
      ],
    );
  }

  group('WalletsProvider Tests', () {
    test('initial state is correct', () async {
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');

      final container = createTestContainer();

      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      verify(() => listener(null, testWallets)).called(1);
    });

    test('updateWallet() updates correctly', () async {
      final newWalletData = WalletData(
        id: '1',
        name: 'Updated Wallet',
        icon: 'https://example.com/icon.png',
        balance: 1000.0,
      );

      final updatedWallets = [
        newWalletData,
        ...testWallets.sublist(1),
      ];

      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(updatedWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');

      final container = createTestContainer();

      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      container.read(walletsRepositoryProvider).updateWallet(newWalletData);

      await Future<void>.delayed(
          Duration.zero); // ждем завершения всех асинхронных операций после обновления

      verify(() => listener(null, testWallets)).called(1);
      verify(() => listener(testWallets, updatedWallets)).called(1);
    });

    test('deleteWallet() removes wallet correctly', () async {
      final updatedWallets = List.of(testWallets.sublist(0, 2));

      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(updatedWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');

      final container = createTestContainer();

      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      container.read(walletsRepositoryProvider).deleteWallet('3');

      await Future<void>.delayed(
          Duration.zero); // ждем завершения всех асинхронных операций после удаления

      verify(() => listener(null, testWallets)).called(1);
      verify(() => listener(testWallets, updatedWallets)).called(1);
    });

    test('addWallet() adds new wallet correctly', () async {
      final newWallet = WalletData(
        id: '4',
        name: 'New Wallet',
        icon: 'https://example.com/icon.png',
        balance: 0.0,
      );

      final updatedWallets = [
        ...testWallets,
        newWallet,
      ];

      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(updatedWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');

      final container = createTestContainer();

      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      container.read(walletsRepositoryProvider).addWallet(newWallet);

      await Future<void>.delayed(
          Duration.zero); // ждем завершения всех асинхронных операций после добавления

      verify(() => listener(null, testWallets)).called(1);
      verify(() => listener(testWallets, updatedWallets)).called(1);
    });
  });

  group('CurrentWallet Provider Tests', () {
    test('currentWalletProvider returns correct data', () async {
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');

      final container = createTestContainer();

      final listener = Listener<WalletData>();
      container.listen(currentWalletProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      verify(() => listener(null, testWallets[0])).called(1);
    });

    test('setCurrentWalletId() updates current wallet', () async {
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('1');
      when(() => mockLocalStorage.setString(any(), any())).thenAnswer((_) async => true);

      final container = createTestContainer();

      final listener = Listener<WalletData>();
      container.listen(currentWalletProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      container.read(selectedWalletIdNotifierProvider.notifier).updateWalletId('2');

      await Future<void>.delayed(
          Duration.zero); // ждем завершения всех асинхронных операций после обновления

      verify(() => listener(null, testWallets[0])).called(1);
      verify(() => listener(testWallets[0], testWallets[1])).called(1);
    });

    test('currentWalletProvider returns first wallet when currentWalletId is not found', () async {
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockLocalStorage.getString(any())).thenReturn('5'); // non-existent ID
      when(() => mockLocalStorage.setString(any(), any())).thenAnswer((_) async => true);

      final container = createTestContainer();

      final listener = Listener<WalletData>();
      container.listen(currentWalletProvider, listener, fireImmediately: true);

      await Future<void>.delayed(Duration.zero); // ждем завершения всех асинхронных операций

      verify(() => listener(null, testWallets[0])).called(1);
    });
  });
}
