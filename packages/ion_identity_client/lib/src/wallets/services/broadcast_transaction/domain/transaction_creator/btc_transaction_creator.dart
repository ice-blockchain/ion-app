// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';

class BtcTransactionCreator implements TransactionCreator {
  @override
  Future<Map<String, dynamic>> createTransaction(TransactionRequest request) async {
    throw UnimplementedError();
    // final amount = request.amount;

    // // Input validation
    // if (!isValidAmount(amount)) {
    //   throw ArgumentError('Invalid amount: must be a positive integer');
    // }

    // const network = Network.testnet;
    // final publicKey = request.wallet.signingKey.publicKey;
    // final addressTo = request.destinationAddress;

    // // Calculate fingerprint from first 4 bytes of public key hash
    // final fingerprint = publicKey.substring(0, 8);

    // final publicKeyDescriptor = await DescriptorPublicKey.fromString(publicKey);

    // // Create descriptor
    // final descriptor = await Descriptor.newBip84Public(
    //   publicKey: publicKeyDescriptor,
    //   network: network,
    //   fingerPrint: fingerprint,
    //   keychain: KeychainKind.externalChain,
    // );

    // final bdkWallet = await Wallet.create(
    //   descriptor: descriptor,
    //   network: network,
    //   databaseConfig: const DatabaseConfig.memory(),
    // );

    // // Sync with blockchain
    // final blockchain = await Blockchain.createTestnet();
    // await bdkWallet.sync(blockchain: blockchain);

    // // Verify wallet has enough funds
    // final balance = bdkWallet.getBalance();
    // final amountSats = BigInt.parse(amount);
    // if (balance.total < amountSats) {
    //   throw InsufficientFundsException(
    //     'Insufficient funds: ${balance.total} < $amountSats',
    //   );
    // }

    // // Validate address
    // final address = await Address.fromString(
    //   s: addressTo,
    //   network: network,
    // );
    // if (!address.isValidForNetwork(network: network)) {
    //   throw ArgumentError('Invalid address for network $network');
    // }

    // final txBuilder = TxBuilder()
    //   ..addRecipient(
    //     address.scriptPubkey(),
    //     amountSats,
    //   )
    //   ..enableRbf();

    // final (psbt, _) = await txBuilder.finish(bdkWallet);
    // final bytes = psbt.serialize();

    // return {
    //   'kind': 'Psbt',
    //   'psbt': '0x${hex.encode(bytes)}',
    // };
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
