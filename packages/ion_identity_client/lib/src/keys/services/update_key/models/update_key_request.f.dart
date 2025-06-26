// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_key_request.f.freezed.dart';
part 'update_key_request.f.g.dart';

@freezed
class UpdateKeyRequest with _$UpdateKeyRequest {
  factory UpdateKeyRequest({
    required String name,
  }) = _UpdateKeyRequest;

  factory UpdateKeyRequest.fromJson(Map<String, dynamic> json) => _$UpdateKeyRequestFromJson(json);
}
