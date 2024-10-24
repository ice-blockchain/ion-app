// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'file_metadata.freezed.dart';

/// https://github.com/nostr-protocol/nips/blob/master/94.md
@freezed
class FileMetadata with _$FileMetadata {
  const factory FileMetadata({
    required String url,
    required String mimeType,
    required String fileHash,
    required String originalFileHash,
    @Default('') String caption,
    int? size,
    String? dimension,
    String? magnet,
    String? torrentInfoHash,
    String? blurhash,
    String? thumb,
    String? image,
    String? summary,
    String? alt,
  }) = _FileMetadata;

  factory FileMetadata.fromUploadResponseTags(List<List<String>> tags, {String? mimeType}) {
    final values = tags.fold(<String, String>{}, (res, tags) {
      return {...res, tags[0]: tags[1]};
    });

    // Only "url" and "ox" are required
    // https://github.com/nostr-protocol/nips/blob/master/96.md#response-codes
    return FileMetadata(
      url: values['url']!,
      mimeType: values['m'] ?? mimeType ?? '',
      fileHash: values['x'] ?? values['ox']!,
      originalFileHash: values['ox']!,
      size: values['size'] != null ? int.parse(values['size']!) : null,
      dimension: values['dim'],
      magnet: values['magnet'],
      torrentInfoHash: values['i'],
      blurhash: values['blurhash'],
      thumb: values['thumb'],
      image: values['image'],
      summary: values['summary'],
      alt: values['alt'],
    );
  }

  const FileMetadata._();

  EventMessage toEventMessage(KeyStore keyStore) {
    final tags = [
      ['url', url],
      ['m', mimeType],
      ['x', fileHash],
      ['ox', originalFileHash],
      if (size != null) ['size', size.toString()],
      if (dimension != null) ['dim', dimension!],
      if (magnet != null) ['magnet', magnet!],
      if (torrentInfoHash != null) ['i', torrentInfoHash!],
      if (blurhash != null) ['blurhash', blurhash!],
      if (thumb != null) ['thumb', thumb!],
      if (image != null) ['image', image!],
      if (summary != null) ['summary', summary!],
      if (alt != null) ['alt', alt!],
    ];

    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      tags: tags,
      content: caption,
    );
  }

  static const int kind = 1063;
}
