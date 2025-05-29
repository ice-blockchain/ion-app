// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_response.c.freezed.dart';
part 'key_response.c.g.dart';

enum KeyStatus {
  @JsonValue('Active')
  active,
  @JsonValue('Archived')
  archived,
}

@freezed
class KeyResponse with _$KeyResponse {
  factory KeyResponse({
    required String id,
    required String scheme,
    required String curve,
    required String publicKey,
    required String? name,
    required KeyStatus status,
    required bool custodial,
    required DateTime dateCreated,
  }) = _KeyResponse;

  factory KeyResponse.fromJson(Map<String, dynamic> json) => _$KeyResponseFromJson(json);
}
