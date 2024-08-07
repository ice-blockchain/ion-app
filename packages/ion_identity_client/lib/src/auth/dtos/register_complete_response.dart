import 'package:ion_identity_client/src/auth/dtos/authentication.dart';
import 'package:ion_identity_client/src/auth/dtos/credential.dart';
import 'package:ion_identity_client/src/auth/dtos/user.dart';
import 'package:ion_identity_client/src/auth/dtos/wallet.dart';
import 'package:ion_identity_client/src/utils/types.dart';

class RegistrationCompleteResponse {
  RegistrationCompleteResponse({
    required this.credential,
    required this.user,
    required this.authentication,
    required this.wallets,
  });

  factory RegistrationCompleteResponse.fromJson(JsonObject json) {
    return RegistrationCompleteResponse(
      credential: Credential.fromJson(json['credential'] as JsonObject),
      user: User.fromJson(json['user'] as JsonObject),
      authentication: Authentication.fromJson(json['authentication'] as JsonObject),
      wallets: List<Wallet>.from(
        (json['wallets'] as List<dynamic>).map<Wallet>(
          (x) => Wallet.fromJson(x as JsonObject),
        ),
      ),
    );
  }

  final Credential credential;
  final User user;
  final Authentication authentication;
  final List<Wallet> wallets;
}
