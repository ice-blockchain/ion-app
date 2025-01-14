// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/btc_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/evm_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/ton_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';

class TransactionCreatorFactory {
  TransactionCreatorFactory()
      : btcCreator = BtcTransactionCreator(),
        ethCreator = EvmTransactionCreator(),
        tonCreator = TonTransactionCreator();

  final BtcTransactionCreator btcCreator;
  final EvmTransactionCreator ethCreator;
  final TonTransactionCreator tonCreator;

  TransactionCreator getCreator(String network) {
    switch (network.toLowerCase()) {
      case 'bitcoin':
      case 'bitcointestnet3':
        return btcCreator;
      case 'ethereum':
      case 'ethereumsepolia':
        return ethCreator;
      case 'ton':
      case 'tontestnet':
      case 'ion':
        return tonCreator;
      default:
        // Clearly handle unknown networks
        throw UnsupportedError('Unsupported network: $network');
    }
  }
}
