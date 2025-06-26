// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/keys/models/key_response.f.dart';

part 'list_keys_response.f.freezed.dart';
part 'list_keys_response.f.g.dart';

@freezed
class ListKeysResponse with _$ListKeysResponse {
  factory ListKeysResponse({
    required List<KeyResponse> items,
    String? nextPageToken,
  }) = _ListKeysResponse;

  factory ListKeysResponse.fromJson(Map<String, dynamic> json) => _$ListKeysResponseFromJson(json);
}
