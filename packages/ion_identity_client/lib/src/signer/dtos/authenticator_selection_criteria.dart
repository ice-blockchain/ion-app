import 'package:ion_identity_client/src/utils/types.dart';

class AuthenticatorSelectionCriteria {
  AuthenticatorSelectionCriteria(
    this.authenticatorAttachment,
    this.residentKey,
    this.requireResidentKey,
    this.userVerification,
  );

  factory AuthenticatorSelectionCriteria.fromJson(JsonObject json) {
    return AuthenticatorSelectionCriteria(
      json['authenticatorAttachment'] as String?,
      json['residentKey'] as String,
      json['requireResidentKey'] as bool,
      json['userVerification'] as String,
    );
  }

  final String? authenticatorAttachment;
  final String residentKey;
  final bool requireResidentKey;
  final String userVerification;
}
