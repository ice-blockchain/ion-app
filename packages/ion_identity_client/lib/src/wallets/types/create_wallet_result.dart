import 'package:ion_identity_client/ion_client.dart';

sealed class CreateWalletResult {
  const CreateWalletResult();
}

class CreateWalletSuccess extends CreateWalletResult {
  const CreateWalletSuccess({
    required this.wallet,
  });

  final Wallet wallet;
}

sealed class CreateWalletFailure extends CreateWalletResult {
  const CreateWalletFailure([
    this.error,
    this.stackTrace,
  ]);

  final Object? error;
  final StackTrace? stackTrace;
}

class UnknownCreateWalletFailure extends CreateWalletFailure {
  const UnknownCreateWalletFailure([
    super.error,
    super.stackTrace,
  ]);
}
