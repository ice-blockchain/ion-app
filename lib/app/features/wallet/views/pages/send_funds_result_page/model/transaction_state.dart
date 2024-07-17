import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_type.dart';

sealed class TransactionState {}

class SuccessContactTransactionState extends TransactionState {
  SuccessContactTransactionState(this.type, this.coin);
  final TransactionType type;
  final CoinData coin;
}

class SuccessSendTransactionState extends TransactionState {
  SuccessSendTransactionState(this.type, this.coin);
  final TransactionType type;
  final CoinData coin;
}

class ErrorTransactionState<T> extends TransactionState {
  ErrorTransactionState(this.coin, this.type, this.errorDetails);
  final TransactionType type;
  final CoinData coin;
  final String errorDetails;
}
