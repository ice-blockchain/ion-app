// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_key_request.f.freezed.dart';
part 'create_key_request.f.g.dart';

@freezed
class CreateKeyRequest with _$CreateKeyRequest {
  factory CreateKeyRequest({
    required String scheme,
    required String curve,
    @JsonKey(includeIfNull: false) String? name,
  }) = _CreateKeyRequest;

  factory CreateKeyRequest.fromJson(Map<String, dynamic> json) => _$CreateKeyRequestFromJson(json);
}
