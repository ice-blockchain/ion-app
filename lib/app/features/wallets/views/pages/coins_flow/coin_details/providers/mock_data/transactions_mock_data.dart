// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

int generateRandomTimestamp() {
  final now = DateTime.now();
  final random = Random();
  final daysAgo = random.nextInt(3); // 0 for today, 1 for yesterday, 2 for the day before
  final targetDay = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysAgo));

  final randomHour = random.nextInt(24);
  final randomMinute = random.nextInt(60);
  final randomSecond = random.nextInt(60);
  final randomDateTime = DateTime(
    targetDay.year,
    targetDay.month,
    targetDay.day,
    randomHour,
    randomMinute,
    randomSecond,
  );

  final timestampMs = randomDateTime.millisecondsSinceEpoch;
  return timestampMs;
}

List<CoinTransactionData> mockedCoinTransactionData = <CoinTransactionData>[
  CoinTransactionData(
    networkType: NetworkType.arbitrum,
    transactionType: TransactionType.send,
    coinAmount: 944.25,
    usdAmount: 30517.11,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.eth,
    transactionType: TransactionType.receive,
    coinAmount: 995.62,
    usdAmount: 26012.75,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.tron,
    transactionType: TransactionType.send,
    coinAmount: 96.16,
    usdAmount: 40392.39,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.matic,
    transactionType: TransactionType.receive,
    coinAmount: 793.17,
    usdAmount: 18236.27,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.solana,
    transactionType: TransactionType.send,
    coinAmount: 46.22,
    usdAmount: 23248.21,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.arbitrum,
    transactionType: TransactionType.receive,
    coinAmount: 166.52,
    usdAmount: 38770.27,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.eth,
    transactionType: TransactionType.send,
    coinAmount: 431.96,
    usdAmount: 23475.52,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.tron,
    transactionType: TransactionType.receive,
    coinAmount: 646.77,
    usdAmount: 44843.07,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.matic,
    transactionType: TransactionType.send,
    coinAmount: 250.97,
    usdAmount: 17588.15,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.solana,
    transactionType: TransactionType.receive,
    coinAmount: 795.63,
    usdAmount: 926.66,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.arbitrum,
    transactionType: TransactionType.send,
    coinAmount: 147.83,
    usdAmount: 41696.85,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.eth,
    transactionType: TransactionType.receive,
    coinAmount: 905.86,
    usdAmount: 25479.18,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.tron,
    transactionType: TransactionType.send,
    coinAmount: 80.7,
    usdAmount: 15383.49,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.matic,
    transactionType: TransactionType.receive,
    coinAmount: 248.84,
    usdAmount: 9622.32,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.solana,
    transactionType: TransactionType.send,
    coinAmount: 389.53,
    usdAmount: 5954.06,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.arbitrum,
    transactionType: TransactionType.receive,
    coinAmount: 110.37,
    usdAmount: 22038.89,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.eth,
    transactionType: TransactionType.send,
    coinAmount: 99.24,
    usdAmount: 14846.89,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.tron,
    transactionType: TransactionType.receive,
    coinAmount: 187.47,
    usdAmount: 18553.68,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.matic,
    transactionType: TransactionType.send,
    coinAmount: 903.26,
    usdAmount: 6389.08,
    timestamp: generateRandomTimestamp(),
  ),
  CoinTransactionData(
    networkType: NetworkType.solana,
    transactionType: TransactionType.receive,
    coinAmount: 26.46,
    usdAmount: 24747.51,
    timestamp: generateRandomTimestamp(),
  ),
];
