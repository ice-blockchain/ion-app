// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: public_member_api_docs, sort_constructors_first
// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/utils/validators.dart';

/// Media attachments (images, videos, and other files) may be added to events by including
/// a URL in the event content, along with a matching imeta tag.
///
/// https://github.com/nostr-protocol/nips/blob/master/92.md
class MediaAttachment {
  MediaAttachment({
    required this.url,
    required this.mimeType,
    required this.dimension,
    required this.alt,
    required this.torrentInfoHash,
    required this.fileHash,
    required this.originalFileHash,
    this.thumb,
  });

  /// https://github.com/nostr-protocol/nips/blob/master/92.md#example
  factory MediaAttachment.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    String? url;
    String? mimeType;
    String? dimension;
    String? thumb;
    String? alt;
    String? torrentInfoHash;
    String? fileHash;
    String? originalFileHash;

    for (final params in tag.skip(1)) {
      final pair = params.split(' ');
      if (pair.length != 2) {
        continue;
      }
      final [key, value] = pair;
      switch (key) {
        case 'url':
          {
            if (!Validators.isInvalidUrl(value)) {
              url = value;
            }
          }
        case 'm':
          mimeType = value;
        case 'dim':
          dimension = value;
        case 'thumb':
          thumb = value;
        case 'alt':
          alt = value;
        case 'i':
          torrentInfoHash = value;
        case 'x':
          fileHash = value;
        case 'ox':
          originalFileHash = value;
      }
    }

    return MediaAttachment(
      url: url!,
      mimeType: mimeType!,
      dimension: dimension!,
      alt: EnumExtensions.fromShortString(FileAlt.values, alt!),
      torrentInfoHash: torrentInfoHash!,
      fileHash: fileHash!,
      originalFileHash: originalFileHash!,
      thumb: thumb,
    );
  }

  final String url;

  final String mimeType;

  final String dimension;

  final FileAlt alt;

  final String fileHash;

  final String originalFileHash;

  final String torrentInfoHash;

  final String? thumb;

  late double? aspectRatio = _aspectRatioFromDimension(dimension);

  late MediaType mediaType = _parseMediaType(url: url, mimeType: mimeType);

  /// Calculates the aspect ratio from a given dimension string.
  ///
  /// This method takes a dimension string in the format of "WIDTHxHEIGHT"
  /// and returns the aspect ratio (WIDTH divided by HEIGHT) as a double.
  /// If the input string is null, not in the correct format, or contains
  /// invalid dimensions (e.g., zero or non-numeric values), it returns null.
  static double? _aspectRatioFromDimension(String? dimension) {
    if (dimension == null) {
      return null;
    }

    final dimensionRegExp = RegExp(r'(\d+)x(\d+)');

    if (!dimensionRegExp.hasMatch(dimension)) {
      return null;
    }

    final match = dimensionRegExp.firstMatch(dimension);
    final width = double.tryParse(match?.group(1) ?? '0').zeroOrValue;
    final height = double.tryParse(match?.group(2) ?? '0').zeroOrValue;

    return width != 0 && height != 0 ? width / height : null;
  }

  static MediaType _parseMediaType({required String url, String? mimeType}) {
    final mediaTypeFromMime = MediaType.fromMimeType(mimeType.emptyOrValue);
    if (mediaTypeFromMime != MediaType.unknown) {
      return mediaTypeFromMime;
    }
    return MediaType.fromUrl(url);
  }

  List<String> toTag() {
    return [
      tagName,
      'url $url',
      'm $mimeType',
      'dim $dimension',
      'i $torrentInfoHash',
      'alt ${alt.toShortString()}',
      'x $fileHash',
      'ox $originalFileHash',
      if (thumb != null) 'thumb $thumb',
    ];
  }

  static const String tagName = 'imeta';

  @override
  String toString() {
    return 'MediaAttachment(url: $url, mimeType: $mimeType, dimension: $dimension, alt: $alt, fileHash: $fileHash, originalFileHash: $originalFileHash, torrentInfoHash: $torrentInfoHash, thumb: $thumb)';
  }
}
