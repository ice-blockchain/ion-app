import 'package:ion_identity_client/src/auth/dtos/dtos.dart';

sealed class ListWalletsResult {}

final class ListWalletsSuccess extends ListWalletsResult {
  ListWalletsSuccess({
    required this.wallets,
  });

  final List<Wallet> wallets;
}

sealed class ListWalletsFailure extends ListWalletsResult {}

final class UnauthorizedListWalletsFailure extends ListWalletsFailure {}

final class UnknownListWalletsFailure extends ListWalletsFailure {}
