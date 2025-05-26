import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_key_response.c.freezed.dart';
part 'create_key_response.c.g.dart';

enum KeyStatus {
  @JsonValue('Active')
  active,
  @JsonValue('Archived')
  archived,
}

@freezed
class CreateKeyResponse with _$CreateKeyResponse {
  factory CreateKeyResponse({
    required String id,
    required String scheme,
    required String curve,
    required String publicKey,
    required KeyStatus status,
    required bool custodial,
    required DateTime dateCreated,
  }) = _CreateKeyResponse;

  factory CreateKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateKeyResponseFromJson(json);
}
