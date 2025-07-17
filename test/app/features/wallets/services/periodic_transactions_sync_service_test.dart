// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/periodic_transactions_sync_service.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncTransactionsService extends Mock implements SyncTransactionsService {}

class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late MockSyncTransactionsService mockSyncTransactionsService;
  late MockTransactionsRepository mockTransactionsRepository;
  late PeriodicTransactionsSyncService service;

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(<TransactionStatus>[]);
  });

  setUp(() {
    mockSyncTransactionsService = MockSyncTransactionsService();
    mockTransactionsRepository = MockTransactionsRepository();
    service = PeriodicTransactionsSyncService(
      mockSyncTransactionsService,
      mockTransactionsRepository,
      initialSyncDelay: const Duration(microseconds: 10),
    );
  });

  tearDown(() {
    service.stopWatching();
  });

  void setupWatchTransactionsMock(StreamController<List<TransactionData>> controller) {
    when(
      () => mockTransactionsRepository.watchTransactions(
        statuses: any(named: 'statuses'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => controller.stream);
  }

  void setupStandardMocks() {
    when(
      () => mockTransactionsRepository.getTransactions(
        statuses: any(named: 'statuses'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => []);

    when(
      () => mockTransactionsRepository.getTransactions(
        walletAddresses: any(named: 'walletAddresses'),
        statuses: any(named: 'statuses'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => []);

    when(
      () => mockSyncTransactionsService.syncBroadcastedTransactionsForWallet(any()),
    ).thenAnswer((_) async {});
  }

  List<TransactionData> createTestTransactions() {
    return [
      _createTransactionWithStatus(
        isSend: true,
        networkTier: 1,
        walletAddress: 'wallet1',
        txHash: 'tx1',
        status: TransactionStatus.executing,
      ),
      _createTransactionWithStatus(
        isSend: true,
        networkTier: 1,
        walletAddress: 'wallet1',
        txHash: 'tx2',
        status: TransactionStatus.pending,
      ),
      _createTransactionWithStatus(
        isSend: true,
        networkTier: 1,
        walletAddress: 'wallet1',
        txHash: 'tx3',
        status: TransactionStatus.broadcasted,
      ),
    ];
  }

  group('PeriodicTransfersSyncService', () {
    group('service lifecycle', () {
      test('can start and stop watching', () {
        setupWatchTransactionsMock(StreamController());

        service
          ..startWatching()
          ..stopWatching();

        verify(
          () => mockTransactionsRepository.watchTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            limit: 100,
          ),
        ).called(1);
      });

      test('does not start watching if already running', () {
        setupWatchTransactionsMock(StreamController());

        service
          ..startWatching()
          ..startWatching();

        verify(
          () => mockTransactionsRepository.watchTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).called(1);
      });
    });

    group('transaction filtering', () {
      test('should sync outgoing transactions in tier 1 networks', () {
        final tx = _createTransaction(
          isSend: true,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        final shouldSync = service.shouldSyncTransaction(tx);
        expect(shouldSync, isTrue);
      });

      test('should sync outgoing transactions in tier 2 networks', () {
        final tx = _createTransaction(
          isSend: true,
          networkTier: 2,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        final shouldSync = service.shouldSyncTransaction(tx);
        expect(shouldSync, isTrue);
      });

      test('should sync incoming transactions in tier 1 networks', () {
        final tx = _createTransaction(
          isSend: false,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        final shouldSync = service.shouldSyncTransaction(tx);
        expect(shouldSync, isTrue);
      });

      test('should NOT sync incoming transactions in tier 2 networks', () {
        final tx = _createTransaction(
          isSend: false,
          networkTier: 2,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        final shouldSync = service.shouldSyncTransaction(tx);
        expect(shouldSync, isFalse);
      });
    });

    group('successful sync flow behavior', () {
      test('triggers _startSyncing when stream emits transactions', () async {
        final streamController = StreamController<List<TransactionData>>();
        final testTransactions = createTestTransactions();

        setupWatchTransactionsMock(streamController);
        setupStandardMocks();

        when(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => testTransactions);

        service.startWatching();
        streamController.add(testTransactions);

        await Future<void>.delayed(const Duration(microseconds: 50));

        verify(
          () => mockTransactionsRepository.getTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            limit: 100,
          ),
        ).called(1);

        await streamController.close();
      });

      test('skips processing when stream emits empty transaction list', () async {
        final streamController = StreamController<List<TransactionData>>();

        setupWatchTransactionsMock(streamController);

        service.startWatching();
        streamController.add([]);

        await Future<void>.delayed(const Duration(microseconds: 50));

        verifyNever(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        );

        await streamController.close();
      });

      test('handles service not running during stream processing', () async {
        final streamController = StreamController<List<TransactionData>>();
        final tx = _createTransaction(
          isSend: true,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        setupWatchTransactionsMock(streamController);

        service
          ..startWatching()
          ..stopWatching();
        streamController.add([tx]);

        await Future<void>.delayed(const Duration(microseconds: 50));

        verifyNever(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        );

        await streamController.close();
      });

      test('executes wallet sync with pending transactions', () async {
        final streamController = StreamController<List<TransactionData>>();
        final pendingTx = _createTransactionWithStatus(
          isSend: true,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
          status: TransactionStatus.pending,
        );

        setupWatchTransactionsMock(streamController);

        when(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => [pendingTx]);

        when(
          () => mockTransactionsRepository.getTransactions(
            walletAddresses: ['wallet1'],
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => [pendingTx]);

        when(
          () => mockSyncTransactionsService.syncBroadcastedTransactionsForWallet('wallet1'),
        ).thenAnswer((_) async {});

        service.startWatching();
        streamController.add([pendingTx]);

        await Future<void>.delayed(const Duration(microseconds: 100));

        verify(
          () => mockSyncTransactionsService.syncBroadcastedTransactionsForWallet('wallet1'),
        ).called(1);

        verify(
          () => mockTransactionsRepository.getTransactions(
            walletAddresses: ['wallet1'],
            statuses: TransactionStatus.inProgressStatuses,
            limit: 100,
          ),
        ).called(2);

        await streamController.close();
      });
    });
  });
}

TransactionData _createTransaction({
  required bool isSend,
  required int networkTier,
  required String walletAddress,
  required String txHash,
}) {
  return TransactionData(
    txHash: txHash,
    walletViewId: 'walletView1',
    network: _createNetwork(tier: networkTier),
    type: isSend ? TransactionType.send : TransactionType.receive,
    cryptoAsset: _createCryptoAsset(),
    senderWalletAddress: isSend ? walletAddress : 'other',
    receiverWalletAddress: isSend ? 'other' : walletAddress,
    fee: '1',
  );
}

TransactionData _createTransactionWithStatus({
  required bool isSend,
  required int networkTier,
  required String walletAddress,
  required String txHash,
  required TransactionStatus status,
}) {
  return TransactionData(
    txHash: txHash,
    walletViewId: 'walletView1',
    network: _createNetwork(tier: networkTier),
    type: isSend ? TransactionType.send : TransactionType.receive,
    cryptoAsset: _createCryptoAsset(),
    senderWalletAddress: isSend ? walletAddress : 'other',
    receiverWalletAddress: isSend ? 'other' : walletAddress,
    fee: '1',
    status: status,
  );
}

NetworkData _createNetwork({required int tier}) {
  return NetworkData(
    id: 'network_$tier',
    image: 'image.png',
    isTestnet: false,
    displayName: 'Test Network',
    explorerUrl: 'https://explorer.test/{txHash}',
    tier: tier,
  );
}

TransactionCryptoAsset _createCryptoAsset() {
  return TransactionCryptoAsset.coin(
    coin: CoinData(
      id: 'Test Coin',
      name: 'Test Coin',
      contractAddress: 'contractAddress',
      decimals: 18,
      iconUrl: 'image.png',
      abbreviation: 'TEST',
      network: _createNetwork(tier: 1),
      priceUSD: 0,
      symbolGroup: '',
      syncFrequency: const Duration(microseconds: 3600000000000),
    ),
    amount: 100,
    amountUSD: 100,
    rawAmount: '100',
  );
}
