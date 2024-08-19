import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';

final class IonApiUserClient {
  const IonApiUserClient({
    required this.auth,
    required this.wallets,
  });

  final IonAuth auth;
  final IonWallets wallets;
}
