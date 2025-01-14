// SPDX-License-Identifier: ice License 1.0

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';
import 'package:tonutils/tonutils.dart';

class TonTransactionCreator implements TransactionCreator {
  TonTransactionCreator() : _client = TonJsonRpc();

  final TonJsonRpc _client;

  static const _maxMessages = 4;
  static const _defaultTimeout = 60;

  static const _transactionKind = 'Transaction';

  @override
  Future<Map<String, dynamic>> createTransaction(TransactionRequest request) async {
    final from = request.wallet;
    final to = request.destinationAddress;
    final value = request.amount;

    final wallet = WalletContractV4R2(Uint8List.fromList(hex.decode(from.signingKey.publicKey)));

    final openedContract = _client.open(wallet);

    final seqno = await openedContract.getSeqno();
    final transfer = _createWalletTransferV4(
      seqno: seqno,
      sendMode: SendMode.payGasSeparately.value,
      walletId: openedContract.walletId,
      messages: [
        internal(
          to: SiaString(to),
          value: SbiString(value),
        ),
      ],
    );

    final transactionBytes = transfer.toBoc();
    final transactionHex = hex.encode(transactionBytes);

    return {
      'kind': _transactionKind,
      'transaction': transactionHex,
    };
  }

  Cell _createWalletTransferV4({
    required int seqno,
    required int sendMode,
    required int walletId,
    required List<MessageRelaxed> messages,
    int? timeout,
  }) {
    if (messages.length > _maxMessages) {
      throw Exception('Expected <= $_maxMessages messages, got ${messages.length}');
    }

    final signingMsg = beginCell().storeUint(BigInt.from(walletId), 32);

    if (seqno == 0) {
      for (var i = 0; i < 32; i += 1) {
        signingMsg.storeBit(1);
      }
    } else {
      // 60 seconds from current timestamp
      final defaultTimeout = BigInt.from(
        (DateTime.now().millisecondsSinceEpoch / 1000).floor() + _defaultTimeout,
      );
      signingMsg.storeUint(
        timeout == null ? defaultTimeout : BigInt.from(timeout),
        32,
      );
    }

    signingMsg
      ..storeUint(BigInt.from(seqno), 32)
      ..storeUint(BigInt.zero, 8); // Simple order

    for (var i = 0; i < messages.length; i += 1) {
      signingMsg
        ..storeUint(BigInt.from(sendMode), 8)
        ..storeRef(beginCell().store(storeMessageRelaxed(messages[i])));
    }

    final body = beginCell().storeBuilder(signingMsg).endCell();

    return body;
  }
}
