import 'package:ion_identity_client/src/core/types/request_defaults.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

class RegisterInitRequest {
  RegisterInitRequest({
    required this.email,
    this.kind = RequestDefaults.registerInitKind,
  });

  final String kind;
  final String email;

  JsonObject toJson() {
    return {
      'email': email,
      'kind': kind,
    };
  }

  @override
  String toString() => 'RegisterInitRequest(kind: $kind, email: $email)';
}
