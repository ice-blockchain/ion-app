import 'package:ion_identity_client/src/auth/dtos/register_complete_wallet.dart';

class RequestDefaults {
  static const registerInitKind = 'EndUser';

  static const registerCompleteWalletNetwork = 'Ton';
  static const registerCompleteWalletName = 'main';
  static const registerCompleteWallets = [
    RegisterCompleteWallet(
      network: registerCompleteWalletNetwork,
      name: registerCompleteWalletName,
    ),
  ];
}
