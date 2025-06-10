// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_storage_metadata.c.freezed.dart';
part 'file_storage_metadata.c.g.dart';

@freezed
class FileStorageMetadata with _$FileStorageMetadata {
  /// https://github.com/nostr-protocol/nips/blob/master/96.md#server-adaptation
  const factory FileStorageMetadata({
    @JsonKey(name: 'api_url') required String apiUrl,
    @JsonKey(name: 'delegated_to_url') String? delegatedToUrl,
  }) = _FileStorageMetadata;

  factory FileStorageMetadata.fromJson(Map<String, dynamic> json) =>
      _$FileStorageMetadataFromJson(json);

  static const String path = '.well-known/nostr/nip96.json';
}
