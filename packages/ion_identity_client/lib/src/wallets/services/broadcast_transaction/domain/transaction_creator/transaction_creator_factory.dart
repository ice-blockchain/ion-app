// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/btc_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/evm_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/ton_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';

class TransactionCreatorFactory {
  TransactionCreatorFactory()
      : btcCreator = BtcTransactionCreator(),
        ethCreator = EvmTransactionCreator();

  final BtcTransactionCreator btcCreator;
  final EvmTransactionCreator ethCreator;

  TransactionCreator getCreator(String network) {
    switch (network.toLowerCase()) {
      case 'bitcoin':
      case 'bitcointestnet3':
        return btcCreator;
      case 'ethereum':
      case 'ethereumsepolia':
        return ethCreator;
      case 'ton':
        return TonTransactionCreator(endpoint: 'https://toncenter.com/api/v2/jsonRPC');
      case 'tontestnet':
        return TonTransactionCreator(endpoint: 'https://testnet.toncenter.com/api/v2/jsonRPC');
      case 'ion':
        return TonTransactionCreator(endpoint: 'https://api.mainnet.ice.io/http/v2/jsonRPC');
      case 'iontestnet':
        return TonTransactionCreator(endpoint: 'https://api.testnet.ice.io/http/v2/jsonRPC');
      default:
        // Clearly handle unknown networks
        throw UnsupportedError('Unsupported network: $network');
    }
  }
}
