import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/modal_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_type.dart';

class TransactionUiModel {
  TransactionUiModel({
    required this.coin,
    required this.state,
    required this.type,
    this.errorDetails,
  });
  final TransactionType type;
  final ModalState state;
  final String? errorDetails;
  final CoinData coin;
}
