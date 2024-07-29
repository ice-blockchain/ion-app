import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
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
  late ProviderContainer container;

  group('currentWalletProvider', () {
    late MockWalletRepository mockRepository;
    late MockLocalStorage mockLocalStorage;

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

    test('returns correct wallet', () {
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

    test('returns first wallet when currentWalletId is not found', () async {
      when(() => mockLocalStorage.getString(any())).thenReturn(nonExistentWalletId);

      final listener = Listener<WalletData>();
      container.listen(currentWalletProvider, listener, fireImmediately: true);

      await pumpEventQueue();

      verify(() => listener(null, testWallets[0])).called(1);
    });
  });

  group('walletsProvider', () {
    late MockWalletRepository mockRepository;

    setUp(() {
      mockRepository = MockWalletRepository();
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(testWallets));
      when(() => mockRepository.wallets).thenReturn(testWallets);

      container = createContainer(
        overrides: [
          walletsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    test('initial state is correct', () {
      final wallets = container.read(walletsProvider);
      expect(wallets, equals(testWallets));
    });

    test('updates when repository stream emits', () async {
      final listener = Listener<List<WalletData>>();
      container.listen(walletsProvider, listener, fireImmediately: true);

      final updatedWallets = [
        WalletData(id: '1', name: 'Updated Wallet', icon: '', balance: 100),
        WalletData(id: '2', name: 'Airdrop wallet', icon: '', balance: 0),
        WalletData(id: '3', name: 'For transfers', icon: '', balance: 0),
      ];
      when(() => mockRepository.walletsStream).thenAnswer((_) => Stream.value(updatedWallets));

      container.invalidate(walletsRepositoryProvider);
      await pumpEventQueue();

      verifyInOrder([
        () => listener(null, testWallets),
        () => listener(testWallets, updatedWallets),
      ]);
    });
  });
}
