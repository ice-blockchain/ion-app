// SPDX-License-Identifier: ice License 1.0

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/btc_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/evm_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/ton_transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/tron_transaction_creator.dart';

class TransactionCreatorFactory {
  TransactionCreatorFactory() : ethCreator = EvmTransactionCreator();

  final EvmTransactionCreator ethCreator;

  TransactionCreator getCreator(String network) {
    switch (network.toLowerCase()) {
      case 'bitcoin':
        return BtcTransactionCreator(network: Network.bitcoin);
      case 'bitcointestnet3':
        return BtcTransactionCreator(network: Network.testnet);
      case 'ethereum':
      case 'ethereumsepolia':
      case 'arbitrumone':
      case 'arbitrumsepolia':
      case 'avalanchec':
      case 'avalanchecfuji':
      case 'base':
      case 'basesepolia':
      case 'bsc':
      case 'bsctestnet':
      case 'fantomopera':
      case 'fantomtestnet':
      case 'optimism':
      case 'optimismsepolia':
      case 'polygon':
      case 'polygonamoy':
        return ethCreator;
      case 'ton':
        return TonTransactionCreator(endpoint: 'https://toncenter.com/api/v2/jsonRPC');
      case 'tontestnet':
        return TonTransactionCreator(endpoint: 'https://testnet.toncenter.com/api/v2/jsonRPC');
      case 'ion':
        return TonTransactionCreator(endpoint: 'https://api.mainnet.ice.io/http/v2/jsonRPC');
      case 'iontestnet':
        return TonTransactionCreator(endpoint: 'https://api.testnet.ice.io/http/v2/jsonRPC');
      case 'tron':
        return TronTransactionCreator(url: 'https://api.trongrid.io');
      case 'tronnile':
        return TronTransactionCreator(url: 'https://nile.trongrid.io');
      default:
        throw UnsupportedError('Unsupported network: $network');
    }
  }
}
