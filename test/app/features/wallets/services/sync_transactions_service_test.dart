// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/transaction_loader.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/transfer_status_updater.r.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/nft_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworksRepository extends Mock implements NetworksRepository {}

class MockCryptoWalletsRepository extends Mock implements CryptoWalletsRepository {}

class MockTransactionLoader extends Mock implements TransactionLoader {}

class MockTransferStatusUpdater extends Mock implements TransferStatusUpdater {}

class MockWalletViewsService extends Mock implements WalletViewsService {}

class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late List<Wallet> mockUserWallets;
  late MockNetworksRepository mockNetworksRepository;
  late MockCryptoWalletsRepository mockCryptoWalletsRepository;
  late MockTransactionLoader mockTransactionLoader;
  late MockTransferStatusUpdater mockTransferStatusUpdater;
  late MockWalletViewsService mockWalletViewsService;
  late MockTransactionsRepository mockTransactionsRepository;
  late SyncTransactionsService service;

  setUpAll(() {
    registerFallbackValue(
      Wallet(
        id: 'fallback',
        network: 'fallback',
        address: 'fallback',
        status: 'active',
        name: 'Fallback Wallet',
        signingKey: WalletSigningKey(
          scheme: 'Ed25519',
          curve: 'Ed25519',
          publicKey: 'fallback_key',
        ),
      ),
    );
  });

  setUp(() {
    mockUserWallets = [
      Wallet(
        id: 'wallet1',
        network: 'network1',
        address: 'address1',
        status: 'active',
        name: 'Bitcoin Wallet',
        signingKey: WalletSigningKey(
          scheme: 'Ed25519',
          curve: 'Ed25519',
          publicKey: 'key1',
        ),
      ),
      Wallet(
        id: 'wallet2',
        network: 'network2',
        address: 'address2',
        status: 'active',
        name: 'Ethereum Wallet',
        signingKey: WalletSigningKey(
          scheme: 'Ed25519',
          curve: 'Ed25519',
          publicKey: 'key2',
        ),
      ),
      Wallet(
        id: 'wallet3',
        network: 'network3',
        address: 'address3',
        status: 'active',
        name: 'Solana Wallet',
        signingKey: WalletSigningKey(
          scheme: 'Ed25519',
          curve: 'Ed25519',
          publicKey: 'key3',
        ),
      ),
      Wallet(
        id: 'wallet4',
        network: 'network4',
        address: 'address4',
        status: 'active',
        name: 'Cardano Wallet',
        signingKey: WalletSigningKey(
          scheme: 'Ed25519',
          curve: 'Ed25519',
          publicKey: 'key4',
        ),
      ),
    ];

    mockNetworksRepository = MockNetworksRepository();
    mockCryptoWalletsRepository = MockCryptoWalletsRepository();
    mockTransactionLoader = MockTransactionLoader();
    mockTransferStatusUpdater = MockTransferStatusUpdater();
    mockWalletViewsService = MockWalletViewsService();
    mockTransactionsRepository = MockTransactionsRepository();

    service = SyncTransactionsService(
      mockUserWallets,
      mockNetworksRepository,
      mockCryptoWalletsRepository,
      mockTransactionLoader,
      mockTransferStatusUpdater,
      mockWalletViewsService,
      mockTransactionsRepository,
    );
  });

  void setupStandardMocks() {
    when(() => mockNetworksRepository.getAllAsMap()).thenAnswer(
      (_) async => {
        'network1': createNetworkData(
          id: 'network1',
          isIonHistorySupported: true,
        ),
        'network2': createNetworkData(
          id: 'network2',
          isIonHistorySupported: true,
        ),
        'network3': createNetworkData(
          id: 'network3',
          isIonHistorySupported: true,
        ),
        'network4': createNetworkData(
          id: 'network4',
          isIonHistorySupported: true,
        ),
      },
    );

    when(() => mockWalletViewsService.lastEmitted).thenReturn([
      createWalletViewData(
        id: 'walletView1',
        walletId: 'wallet1',
        symbolGroup: 'BTC',
      ),
      createWalletViewData(
        id: 'walletView2',
        walletId: 'wallet2',
        symbolGroup: 'ETH',
      ),
      createWalletViewData(
        id: 'walletView3',
        walletId: 'wallet3',
        symbolGroup: 'SOL',
      ),
      createWalletViewData(
        id: 'walletView4',
        walletId: 'wallet4',
        symbolGroup: 'ADA',
      ),
    ]);

    when(() => mockWalletViewsService.walletViews).thenAnswer(
      (_) => Stream.value([
        createWalletViewData(
          id: 'walletView1',
          walletId: 'wallet1',
          symbolGroup: 'BTC',
        ),
        createWalletViewData(
          id: 'walletView2',
          walletId: 'wallet2',
          symbolGroup: 'ETH',
        ),
        createWalletViewData(
          id: 'walletView3',
          walletId: 'wallet3',
          symbolGroup: 'SOL',
        ),
        createWalletViewData(
          id: 'walletView4',
          walletId: 'wallet4',
          symbolGroup: 'ADA',
        ),
      ]),
    );
  }

  void setupBroadcastedTransfersMocks() {
    when(() => mockNetworksRepository.getAllAsMap()).thenAnswer(
      (_) async => {
        'network1': createNetworkData(
          id: 'network1',
          isIonHistorySupported: true,
        ),
        'network2': createNetworkData(
          id: 'network2',
          isIonHistorySupported: false,
        ),
        'network3': createNetworkData(
          id: 'network3',
          isIonHistorySupported: true,
        ),
        'network4': createNetworkData(
          id: 'network4',
          isIonHistorySupported: true,
        ),
      },
    );

    when(() => mockWalletViewsService.lastEmitted).thenReturn([
      createWalletViewData(
        id: 'walletView1',
        walletId: 'wallet1',
        symbolGroup: 'BTC',
      ),
      createWalletViewData(
        id: 'walletView2',
        walletId: 'wallet2',
        symbolGroup: 'ETH',
      ),
    ]);

    when(() => mockWalletViewsService.walletViews).thenAnswer(
      (_) => Stream.value([
        createWalletViewData(
          id: 'walletView1',
          walletId: 'wallet1',
          symbolGroup: 'BTC',
        ),
        createWalletViewData(
          id: 'walletView2',
          walletId: 'wallet2',
          symbolGroup: 'ETH',
        ),
      ]),
    );
  }

  List<TransactionData> createBroadcastedTransfersTestData() {
    return [
      createTransactionData(
        txHash: 'tx1',
        network: 'network1',
        type: TransactionType.send,
        status: TransactionStatus.broadcasted,
        senderWalletAddress: 'address1',
        receiverWalletAddress: 'other1',
      ),
      createTransactionData(
        txHash: 'tx2',
        network: 'network2',
        type: TransactionType.send,
        status: TransactionStatus.executing,
        senderWalletAddress: 'address2',
        receiverWalletAddress: 'other2',
      ),
      createTransactionData(
        txHash: 'tx3',
        network: 'network3',
        type: TransactionType.receive,
        status: TransactionStatus.pending,
        senderWalletAddress: 'other3',
        receiverWalletAddress: 'address3',
      ),
      createTransactionData(
        txHash: 'tx4',
        network: 'network4',
        type: TransactionType.receive,
        status: TransactionStatus.broadcasted,
        senderWalletAddress: 'other4',
        receiverWalletAddress: 'address4',
      ),
      createTransactionData(
        txHash: 'tx5',
        network: 'network1',
        type: TransactionType.send,
        status: TransactionStatus.executing,
        senderWalletAddress: 'unknown_address',
        receiverWalletAddress: 'other5',
      ),
      createTransactionData(
        txHash: 'tx6',
        network: 'network1',
        type: TransactionType.send,
        status: TransactionStatus.broadcasted,
        senderWalletAddress: null,
        receiverWalletAddress: 'other6',
      ),
    ];
  }

  group('SyncTransactionsService', () {
    group('syncAll', () {
      test('syncs 3 wallets with ion history support and transaction loader returns false',
          () async {
        setupStandardMocks();

        when(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: any(named: 'walletId'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        when(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        ).thenAnswer((_) async {});

        await service.syncAll();

        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet1',
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet2',
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet3',
          ),
        ).called(1);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[0],
            walletViewId: 'walletView1',
            isFullLoad: true,
          ),
        ).called(1);
        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[1],
            walletViewId: 'walletView2',
            isFullLoad: true,
          ),
        ).called(1);
        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[2],
            walletViewId: 'walletView3',
            isFullLoad: true,
          ),
        ).called(1);

        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[0]),
        ).called(1);
        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[1]),
        ).called(1);
        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[2]),
        ).called(1);

        verify(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[0],
            isHistoryLoaded: true,
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[1],
            isHistoryLoaded: true,
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[2],
            isHistoryLoaded: true,
          ),
        ).called(1);
      });

      test('skips sync when wallet network is not supported', () async {
        when(() => mockNetworksRepository.getAllAsMap()).thenAnswer(
          (_) async => {
            'network1': createNetworkData(
              id: 'network1',
              isIonHistorySupported: true,
            ),
            // network2 is missing - not supported
          },
        );

        when(() => mockWalletViewsService.lastEmitted).thenReturn([
          createWalletViewData(
            id: 'walletView1',
            walletId: 'wallet1',
            symbolGroup: 'BTC',
          ),
          createWalletViewData(
            id: 'walletView2',
            walletId: 'wallet2',
            symbolGroup: 'ETH',
          ),
        ]);

        when(() => mockWalletViewsService.walletViews).thenAnswer(
          (_) => Stream.value([
            createWalletViewData(
              id: 'walletView1',
              walletId: 'wallet1',
              symbolGroup: 'BTC',
            ),
            createWalletViewData(
              id: 'walletView2',
              walletId: 'wallet2',
              symbolGroup: 'ETH',
            ),
          ]),
        );

        when(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: any(named: 'walletId'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        when(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        ).thenAnswer((_) async {});

        await service.syncAll();

        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet1',
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet2',
          ),
        ).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[1],
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(mockUserWallets[1]),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[1],
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });

      test('skips sync when wallet is not connected to any wallet view', () async {
        when(() => mockNetworksRepository.getAllAsMap()).thenAnswer(
          (_) async => {
            'network1': createNetworkData(
              id: 'network1',
              isIonHistorySupported: true,
            ),
            'network2': createNetworkData(
              id: 'network2',
              isIonHistorySupported: true,
            ),
          },
        );

        when(() => mockWalletViewsService.lastEmitted).thenReturn([
          createWalletViewData(
            id: 'walletView1',
            walletId: 'wallet1',
            symbolGroup: 'BTC',
          ),
          // walletView2 is missing - wallet2 not connected
        ]);

        when(() => mockWalletViewsService.walletViews).thenAnswer(
          (_) => Stream.value([
            createWalletViewData(
              id: 'walletView1',
              walletId: 'wallet1',
              symbolGroup: 'BTC',
            ),
            // walletView2 is missing - wallet2 not connected
          ]),
        );

        when(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: any(named: 'walletId'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        when(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        ).thenAnswer((_) async {});

        await service.syncAll();

        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet1',
          ),
        ).called(1);
        verify(
          () => mockCryptoWalletsRepository.isHistoryLoadedForWallet(
            walletId: 'wallet2',
          ),
        ).called(1);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[0],
            walletViewId: 'walletView1',
            isFullLoad: true,
          ),
        ).called(1);

        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[0]),
        ).called(1);

        verify(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[0],
            isHistoryLoaded: true,
          ),
        ).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[1],
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(mockUserWallets[1]),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: mockUserWallets[1],
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });
    });

    group('syncBroadcastedTransfers', () {
      test('syncs only wallets with broadcasted transfers from user wallets', () async {
        setupBroadcastedTransfersMocks();

        final broadcastedTransfers = createBroadcastedTransfersTestData();
        when(() => mockTransactionsRepository.getBroadcastedTransfers())
            .thenAnswer((_) async => broadcastedTransfers);

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => true);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        await service.syncBroadcastedTransfers();

        verify(() => mockTransactionsRepository.getBroadcastedTransfers()).called(1);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[0],
            walletViewId: 'walletView1',
            isFullLoad: false,
          ),
        ).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[1],
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[1]),
        ).called(1);

        verifyNever(
          () => mockTransferStatusUpdater.update(mockUserWallets[0]),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });

      test('skips sync when no broadcasted transfers are found', () async {
        setupBroadcastedTransfersMocks();

        when(() => mockTransactionsRepository.getBroadcastedTransfers())
            .thenAnswer((_) async => []);

        await service.syncBroadcastedTransfers();

        verify(() => mockTransactionsRepository.getBroadcastedTransfers()).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(any()),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });
    });

    group('syncBroadcastedTransactionsForWallet', () {
      test('throws exception when wallet not found in user wallets', () async {
        expect(
          () => service.syncBroadcastedTransactionsForWallet('unknown_address'),
          throwsA(isA<WalletNotFoundException>()),
        );
      });

      test('skips sync when no in-progress transactions found for wallet', () async {
        setupStandardMocks();

        when(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            walletAddresses: any(named: 'walletAddresses'),
          ),
        ).thenAnswer((_) async => []);

        await service.syncBroadcastedTransactionsForWallet('address1');

        verify(
          () => mockTransactionsRepository.getTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            walletAddresses: ['address1'],
          ),
        ).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(any()),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });

      test('syncs wallet when in-progress transactions found', () async {
        setupStandardMocks();

        final inProgressTransactions = [
          createTransactionData(
            txHash: 'tx1',
            network: 'network1',
            type: TransactionType.send,
            status: TransactionStatus.executing,
            senderWalletAddress: 'address1',
            receiverWalletAddress: 'other1',
          ),
          createTransactionData(
            txHash: 'tx2',
            network: 'network1',
            type: TransactionType.receive,
            status: TransactionStatus.pending,
            senderWalletAddress: 'other2',
            receiverWalletAddress: 'address1',
          ),
        ];

        when(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            walletAddresses: any(named: 'walletAddresses'),
          ),
        ).thenAnswer((_) async => inProgressTransactions);

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => true);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        await service.syncBroadcastedTransactionsForWallet('address1');

        verify(
          () => mockTransactionsRepository.getTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            walletAddresses: ['address1'],
          ),
        ).called(1);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[0],
            walletViewId: 'walletView1',
            isFullLoad: false,
          ),
        ).called(1);

        verifyNever(
          () => mockTransferStatusUpdater.update(mockUserWallets[0]),
        );

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });
    });

    group('syncCoinTransactions', () {
      test('skips sync when empty symbol group provided', () async {
        when(() => mockWalletViewsService.lastEmitted).thenReturn([]);
        when(() => mockWalletViewsService.walletViews).thenAnswer(
          (_) => Stream.value([]),
        );

        await service.syncCoinTransactions('');

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(any()),
        );
      });

      test('skips sync when no wallets found with the specified coin', () async {
        setupStandardMocks();

        when(() => mockWalletViewsService.lastEmitted).thenReturn([]);

        when(() => mockWalletViewsService.walletViews).thenAnswer(
          (_) => Stream.value([
            createWalletViewDataWithCoin(
              id: 'walletView1',
              walletId: 'wallet1',
              symbolGroup: 'BTC',
            ),
          ]),
        );

        await service.syncCoinTransactions('ETH');

        verify(() => mockWalletViewsService.walletViews).called(1);

        verifyNever(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        );

        verifyNever(
          () => mockTransferStatusUpdater.update(any()),
        );
      });

      test('syncs wallets that have the specified coin', () async {
        when(() => mockNetworksRepository.getAllAsMap()).thenAnswer(
          (_) async => {
            'network1': createNetworkData(
              id: 'network1',
              isIonHistorySupported: true,
            ),
            'network2': createNetworkData(
              id: 'network2',
              isIonHistorySupported: true,
            ),
          },
        );

        when(() => mockWalletViewsService.lastEmitted).thenReturn([]);

        when(() => mockWalletViewsService.walletViews).thenAnswer(
          (_) => Stream.value([
            createWalletViewDataWithCoin(
              id: 'walletView1',
              walletId: 'wallet1',
              symbolGroup: 'BTC',
              networkId: 'network1',
            ),
            createWalletViewDataWithCoin(
              id: 'walletView2',
              walletId: 'wallet2',
              symbolGroup: 'BTC',
              networkId: 'network2',
            ),
            createWalletViewDataWithCoin(
              id: 'walletView3',
              walletId: 'unknown_wallet',
              symbolGroup: 'BTC',
            ),
          ]),
        );

        when(
          () => mockTransactionLoader.load(
            wallet: any(named: 'wallet'),
            walletViewId: any(named: 'walletViewId'),
            isFullLoad: any(named: 'isFullLoad'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockTransferStatusUpdater.update(any()),
        ).thenAnswer((_) async {});

        await service.syncCoinTransactions('BTC');

        // 1 - inside _getWalletsWithCoin
        // 2 - for each connected wallet inside _syncWallet
        verify(() => mockWalletViewsService.walletViews).called(3);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[0],
            walletViewId: 'walletView1',
            isFullLoad: false,
          ),
        ).called(1);

        verify(
          () => mockTransactionLoader.load(
            wallet: mockUserWallets[1],
            walletViewId: 'walletView2',
            isFullLoad: false,
          ),
        ).called(1);

        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[0]),
        ).called(1);

        verify(
          () => mockTransferStatusUpdater.update(mockUserWallets[1]),
        ).called(1);

        verifyNever(
          () => mockCryptoWalletsRepository.save(
            wallet: any(named: 'wallet'),
            isHistoryLoaded: any(named: 'isHistoryLoaded'),
          ),
        );
      });
    });
  });
}

TransactionData createTransactionData({
  required String txHash,
  required String network,
  required TransactionType type,
  required TransactionStatus status,
  required String? senderWalletAddress,
  required String? receiverWalletAddress,
}) {
  return TransactionData(
    txHash: txHash,
    walletViewId: 'walletView1',
    network: createNetworkData(
      id: network,
      isIonHistorySupported: network != 'network2',
    ),
    type: type,
    cryptoAsset: createTransactionCryptoAsset(),
    senderWalletAddress: senderWalletAddress,
    receiverWalletAddress: receiverWalletAddress,
    fee: '1',
    status: status,
  );
}

TransactionCryptoAsset createTransactionCryptoAsset() {
  return TransactionCryptoAsset.coin(
    coin: CoinData(
      id: 'Test Coin',
      name: 'Test Coin',
      contractAddress: 'contractAddress',
      decimals: 18,
      iconUrl: 'image.png',
      abbreviation: 'TEST',
      network: createNetworkData(
        id: 'network1',
        isIonHistorySupported: true,
      ),
      priceUSD: 0,
      symbolGroup: '',
      syncFrequency: const Duration(hours: 1),
    ),
    amount: 100,
    amountUSD: 100,
    rawAmount: '100',
  );
}

NetworkData createNetworkData({
  required String id,
  required bool isIonHistorySupported,
}) {
  return NetworkData(
    id: id,
    image: 'image.png',
    isTestnet: false,
    displayName: 'Test Network',
    explorerUrl: 'https://explorer.test/{txHash}',
    tier: isIonHistorySupported ? 1 : 2,
  );
}

WalletViewData createWalletViewData({
  required String id,
  required String walletId,
  required String symbolGroup,
}) {
  final coinData = CoinData(
    id: '$symbolGroup-coin',
    name: '$symbolGroup Coin',
    contractAddress: 'contract-$symbolGroup',
    decimals: 18,
    iconUrl: 'icon.png',
    abbreviation: symbolGroup,
    network: createNetworkData(
      id: 'network1',
      isIonHistorySupported: true,
    ),
    priceUSD: 0,
    symbolGroup: symbolGroup,
    syncFrequency: const Duration(hours: 1),
  );

  final coinInWallet = CoinInWalletData(
    coin: coinData,
    walletId: walletId,
    walletAddress: 'address1',
  );

  final coinsGroup = CoinsGroup(
    name: '$symbolGroup Group',
    iconUrl: 'icon.png',
    symbolGroup: symbolGroup,
    abbreviation: symbolGroup,
    coins: [coinInWallet],
  );

  return WalletViewData(
    id: id,
    name: '$symbolGroup Wallet View',
    coinGroups: [coinsGroup],
    symbolGroups: {symbolGroup},
    nfts: const <NftData>[],
    usdBalance: 0.0,
    createdAt: 0,
    updatedAt: 0,
    isMainWalletView: true,
  );
}

WalletViewData createWalletViewDataWithCoin({
  required String id,
  required String walletId,
  required String symbolGroup,
  String? networkId,
}) {
  final coinData = CoinData(
    id: '$symbolGroup-coin',
    name: '$symbolGroup Coin',
    contractAddress: 'contract-$symbolGroup',
    decimals: 18,
    iconUrl: 'icon.png',
    abbreviation: symbolGroup,
    network: createNetworkData(
      id: networkId ?? 'network1',
      isIonHistorySupported: true,
    ),
    priceUSD: 0,
    symbolGroup: symbolGroup,
    syncFrequency: const Duration(hours: 1),
  );

  final coinInWallet = CoinInWalletData(
    coin: coinData,
    walletId: walletId,
    walletAddress: 'address1',
  );

  final coinsGroup = CoinsGroup(
    name: '$symbolGroup Group',
    iconUrl: 'icon.png',
    symbolGroup: symbolGroup,
    abbreviation: symbolGroup,
    coins: [coinInWallet],
  );

  return WalletViewData(
    id: id,
    name: '$symbolGroup Wallet View',
    coinGroups: [coinsGroup],
    symbolGroups: {symbolGroup},
    nfts: const <NftData>[],
    usdBalance: 0.0,
    createdAt: 0,
    updatedAt: 0,
    isMainWalletView: true,
  );
}
