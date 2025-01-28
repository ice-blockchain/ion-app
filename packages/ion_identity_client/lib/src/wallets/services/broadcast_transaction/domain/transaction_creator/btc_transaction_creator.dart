// SPDX-License-Identifier: ice License 1.0

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:convert/convert.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';

class BtcTransactionCreator implements TransactionCreator {
  BtcTransactionCreator({
    required this.network,
  });

  final Network network;

  static const _electrumStopGap = 20;
  static const _electrumTimeout = 10;
  static const _electrumRetry = 5;

  @override
  Future<Map<String, dynamic>> createTransaction(TransactionRequest request) async {
    final amount = request.amount;

    // Input validation
    if (!isValidAmount(amount)) {
      throw ArgumentError('Invalid amount: must be a positive integer');
    }

    final publicKey = request.wallet.signingKey.publicKey;
    final addressTo = request.destinationAddress;

    final descriptor = await Descriptor.create(
      descriptor: 'wpkh($publicKey)',
      network: network,
    );

    final bdkWallet = await Wallet.create(
      descriptor: descriptor,
      network: network,
      databaseConfig: const DatabaseConfig.memory(),
    );

    // Sync with blockchain
    final blockchain = await _getBlockchain(network);
    await bdkWallet.sync(blockchain: blockchain);

    // Verify wallet has enough funds
    final balance = bdkWallet.getBalance();
    final amountSats = BigInt.parse(amount);
    if (balance.total < amountSats) {
      throw InsufficientFundsException(
        'Insufficient funds: ${balance.total} < $amountSats',
      );
    }

    // Validate address
    final address = await Address.fromString(
      s: addressTo,
      network: network,
    );
    if (!address.isValidForNetwork(network: network)) {
      throw ArgumentError('Invalid address for network $network');
    }

    final txBuilder = TxBuilder()
      ..addRecipient(
        address.scriptPubkey(),
        amountSats,
      )
      ..enableRbf();

    final (psbt, _) = await txBuilder.finish(bdkWallet);
    final bytes = psbt.serialize();

    return {
      'kind': 'Psbt',
      'psbt': '0x${hex.encode(bytes)}',
    };
  }

  Future<Blockchain> _getBlockchain(Network network) async {
    final electrumUrl = switch (network) {
      Network.bitcoin => 'ssl://electrum.blockstream.info:50002',
      Network.testnet => 'ssl://electrum.blockstream.info:60002',
      _ => throw UnsupportedError('Unsupported network: $network'),
    };

    return Blockchain.create(
      config: BlockchainConfig.electrum(
        config: ElectrumConfig(
          stopGap: BigInt.from(_electrumStopGap),
          timeout: _electrumTimeout,
          retry: _electrumRetry,
          url: electrumUrl,
          validateDomain: true,
        ),
      ),
    );
  }
}

// Custom exceptions
class InsufficientFundsException implements Exception {
  const InsufficientFundsException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PsbtCreationException implements Exception {
  const PsbtCreationException(this.message);

  final String message;

  @override
  String toString() => message;
}

// Helper function to validate amount
bool isValidAmount(String amount) {
  try {
    final value = BigInt.parse(amount);
    return value > BigInt.zero;
  } catch (_) {
    return false;
  }
}
