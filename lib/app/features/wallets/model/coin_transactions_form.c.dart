import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';

part 'coin_transactions_form.c.freezed.dart';

@freezed
class CoinTransactionsForm with _$CoinTransactionsForm {
  const factory CoinTransactionsForm({
    required List<NetworkData> networks,
    required NetworkData selectedNetwork,
    required List<CoinTransactionData> transactions,
  }) = _CoinTransactionsForm;
}
