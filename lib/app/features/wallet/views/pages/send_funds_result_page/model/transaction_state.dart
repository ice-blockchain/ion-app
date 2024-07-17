sealed class TransactionState {}

class Success extends TransactionState {}

class Error extends TransactionState {
  Error(this.errorDetails);
  final String errorDetails;
}
