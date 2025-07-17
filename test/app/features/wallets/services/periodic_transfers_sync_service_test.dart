// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/periodic_transfers_sync_service.r.dart';
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
  late PeriodicTransfersSyncService service;

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(<TransactionStatus>[]);
  });

  setUp(() {
    mockSyncTransactionsService = MockSyncTransactionsService();
    mockTransactionsRepository = MockTransactionsRepository();
    service = PeriodicTransfersSyncService(
      mockSyncTransactionsService,
      mockTransactionsRepository,
    );
  });

  tearDown(() {
    service.stopWatching();
  });

  group('PeriodicTransfersSyncService', () {
    group('service lifecycle', () {
      test('can start and stop watching', () {
        when(
          () => mockTransactionsRepository.watchTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => const Stream.empty());

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
        when(
          () => mockTransactionsRepository.watchTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => const Stream.empty());

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

    group('transaction processing', () {
      test('filters transactions correctly when processing', () {
        final tier1IncomingTx = _createTransaction(
          isSend: false,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );
        final tier2IncomingTx = _createTransaction(
          isSend: false,
          networkTier: 2,
          walletAddress: 'wallet2',
          txHash: 'tx2',
        );
        final tier2OutgoingTx = _createTransaction(
          isSend: true,
          networkTier: 2,
          walletAddress: 'wallet3',
          txHash: 'tx3',
        );

        final allTransactions = [tier1IncomingTx, tier2IncomingTx, tier2OutgoingTx];

        // Test the filtering logic
        final shouldSyncTier1Incoming = service.shouldSyncTransaction(tier1IncomingTx);
        final shouldSyncTier2Incoming = service.shouldSyncTransaction(tier2IncomingTx);
        final shouldSyncTier2Outgoing = service.shouldSyncTransaction(tier2OutgoingTx);

        expect(shouldSyncTier1Incoming, isTrue, reason: 'Tier 1 incoming should be synced');
        expect(shouldSyncTier2Incoming, isFalse, reason: 'Tier 2 incoming should NOT be synced');
        expect(shouldSyncTier2Outgoing, isTrue, reason: 'Tier 2 outgoing should be synced');

        // Count transactions that should be synced
        final transactionsToSync = allTransactions.where(service.shouldSyncTransaction).toList();
        expect(transactionsToSync.length, 2, reason: 'Should sync 2 out of 3 transactions');
        expect(transactionsToSync, contains(tier1IncomingTx));
        expect(transactionsToSync, contains(tier2OutgoingTx));
        expect(transactionsToSync, isNot(contains(tier2IncomingTx)));
      });

      test('handles empty transaction list', () {
        final emptyList = <TransactionData>[];
        final transactionsToSync = emptyList.where(service.shouldSyncTransaction).toList();
        expect(transactionsToSync, isEmpty);
      });
    });

    group('stream processing', () {
      test('starts watching with correct parameters', () {
        final streamController = StreamController<List<TransactionData>>();

        when(
          () => mockTransactionsRepository.watchTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => streamController.stream);

        service.startWatching();

        verify(
          () => mockTransactionsRepository.watchTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            limit: 100,
          ),
        ).called(1);

        streamController.close();
      });

      test('handles stream events', () async {
        final streamController = StreamController<List<TransactionData>>();

        when(
          () => mockTransactionsRepository.watchTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => streamController.stream);

        when(
          () => mockTransactionsRepository.getTransactions(
            statuses: any(named: 'statuses'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        service.startWatching();

        final tx = _createTransaction(
          isSend: true,
          networkTier: 1,
          walletAddress: 'wallet1',
          txHash: 'tx1',
        );

        streamController.add([tx]);

        // Give time for stream processing
        await Future<void>.delayed(const Duration(milliseconds: 10));

        verify(
          () => mockTransactionsRepository.getTransactions(
            statuses: TransactionStatus.inProgressStatuses,
            limit: 100,
          ),
        ).called(1);

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
