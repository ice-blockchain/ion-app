import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../test_utils.dart';

final testWallets = [
  WalletData(id: '1', name: 'ice.wallet', icon: '', balance: 0),
  WalletData(id: '2', name: 'Airdrop wallet', icon: '', balance: 0),
  WalletData(id: '3', name: 'For transfers', icon: '', balance: 0),
];

void main() {
  late MockWalletRepository mockRepository;

  setUp(() {
    mockRepository = MockWalletRepository();
  });

  group('WalletsRepositoryNotifier Tests', () {
    test('initial state is correct', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      when(() => mockRepository.wallets).thenReturn(testWallets);

      final walletData = container.read(walletsRepositoryNotifierProvider);

      expect(walletData.length, 3);
      expect(walletData[0].name, 'ice.wallet');
      expect(walletData[1].name, 'Airdrop wallet');
      expect(walletData[2].name, 'For transfers');
    });

    test('updateWallet() updates correctly', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final initialWallets = [testWallets.first];
      when(() => mockRepository.wallets).thenReturn(initialWallets);

      final walletsRepositoryNotifier = container.read(walletsRepositoryNotifierProvider.notifier);

      final newWalletData = WalletData(
        id: '1',
        name: 'Updated Wallet',
        icon: 'https://example.com/icon.png',
        balance: 1000.0,
      );

      when(() => mockRepository.updateWallet(newWalletData)).thenAnswer((_) {
        initialWallets[0] = newWalletData;
      });

      when(() => mockRepository.wallets).thenReturn([newWalletData]);

      walletsRepositoryNotifier.updateWallet(newWalletData);

      final walletData = container.read(walletsRepositoryNotifierProvider);

      expect(walletData.first.name, 'Updated Wallet');
      expect(walletData.first.balance, 1000.0);
    });

    test('deleteWallet() removes wallet correctly', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final initialWallets = List.of(testWallets.sublist(0, 2));
      when(() => mockRepository.wallets).thenReturn(initialWallets);

      final walletsRepositoryNotifier = container.read(walletsRepositoryNotifierProvider.notifier);

      when(() => mockRepository.deleteWallet('2')).thenAnswer((_) {
        initialWallets.removeWhere((wallet) => wallet.id == '2');
      });

      walletsRepositoryNotifier.deleteWallet('2');

      final walletData = container.read(walletsRepositoryNotifierProvider);

      expect(walletData.length, 1);
      expect(walletData.first.id, '1');
    });

    test('addWallet() adds new wallet correctly', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final initialWallets = List.of([testWallets.first]);
      when(() => mockRepository.wallets).thenReturn(initialWallets);

      final walletRepositoryNotifier = container.read(walletsRepositoryNotifierProvider.notifier);

      final newWallet = WalletData(
        id: '4',
        name: 'New Wallet',
        icon: 'https://example.com/icon.png',
        balance: 0.0,
      );

      when(() => mockRepository.addWallet(newWallet)).thenAnswer((_) {
        initialWallets.add(newWallet);
      });

      walletRepositoryNotifier.addWallet(newWallet);

      final walletData = container.read(walletsRepositoryNotifierProvider);

      expect(walletData.length, 2);
      expect(walletData[1].id, '4');
      expect(walletData[1].name, 'New Wallet');
    });

    test('setCurrentWalletId() updates current wallet', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      when(() => mockRepository.wallets).thenReturn(testWallets);
      when(() => mockRepository.currentWalletId).thenReturn('1');

      final walletsRepositoryNotifier = container.read(walletsRepositoryNotifierProvider.notifier);

      walletsRepositoryNotifier.setCurrentWalletId('2');

      when(() => mockRepository.currentWalletId).thenReturn('2');

      final currentWallet = container.read(currentWalletProvider);

      expect(currentWallet.id, '2');
      expect(currentWallet.name, 'Airdrop wallet');
    });
  });

  group('CurrentWallet Provider Tests', () {
    test('currentWalletProvider returns correct data', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      when(() => mockRepository.currentWalletId).thenReturn('1');
      when(() => mockRepository.wallets).thenReturn(testWallets);

      final currentWallet = container.read(currentWalletProvider);

      expect(currentWallet.id, '1');
      expect(currentWallet.name, 'ice.wallet');
    });

    test('currentWalletProvider returns first wallet when currentWalletId is not found', () {
      final container = createContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      when(() => mockRepository.currentWalletId).thenReturn('5'); // non-existent ID
      when(() => mockRepository.wallets).thenReturn(testWallets);

      final currentWallet = container.read(currentWalletProvider);

      expect(currentWallet.id, '1');
      expect(currentWallet.name, 'ice.wallet');
    });
  });
}
