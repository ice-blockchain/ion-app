// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_signature_request.c.freezed.dart';
part 'generate_signature_request.c.g.dart';

@freezed
class SignatureRequestHash with _$SignatureRequestHash {
  const factory SignatureRequestHash({
    required String kind,
    required String hash,
    @JsonKey(includeIfNull: false) String? externalId,
  }) = _SignatureRequestHash;

  factory SignatureRequestHash.fromJson(Map<String, dynamic> json) =>
      _$SignatureRequestHashFromJson(json);
}

@freezed
class SignatureRequestMessage with _$SignatureRequestMessage {
  const factory SignatureRequestMessage({
    required String kind,
    required String message,
    @JsonKey(includeIfNull: false) String? externalId,
  }) = _SignatureRequestMessage;

  factory SignatureRequestMessage.fromJson(Map<String, dynamic> json) =>
      _$SignatureRequestMessageFromJson(json);
}
