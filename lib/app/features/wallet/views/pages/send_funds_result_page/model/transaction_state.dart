sealed class TransactionState {}

class SuccessContact extends TransactionState {}

class SuccessSend extends TransactionState {}

class Error extends TransactionState {
  Error(this.errorDetails);
  final String errorDetails;
}
