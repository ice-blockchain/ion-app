// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';

/// Media attachments (images, videos, and other files) may be added to events by including
/// a URL in the event content, along with a matching imeta tag.
///
/// https://github.com/nostr-protocol/nips/blob/master/92.md
class MediaAttachment {
  MediaAttachment({
    required this.url,
    this.mimeType,
    this.blurhash,
    this.dimension,
  });

  /// https://github.com/nostr-protocol/nips/blob/master/92.md#example
  factory MediaAttachment.fromTag(List<String> tag) {
    if (tag[0] != 'imeta') {
      throw Exception('Wrong tags ${tag[0]}, expected "imeta"');
    }

    String? url;
    String? mimeType;
    String? blurhash;
    String? dimension;

    for (final params in tag.skip(1)) {
      final pair = params.split(' ');
      if (pair.length != 2) {
        continue;
      }
      final [key, value] = pair;
      switch (key) {
        case 'url':
          {
            if ((Uri.tryParse(value)?.isAbsolute).falseOrValue) {
              url = value;
            }
          }
        case 'm':
          mimeType = value;
        case 'blurhash':
          blurhash = value;
        case 'dim':
          dimension = value;
      }
    }

    if (url == null) {
      throw Exception('Url is not found in imeta tag');
    }

    return MediaAttachment(
      url: url,
      mimeType: mimeType,
      dimension: dimension,
      blurhash: blurhash,
    );
  }

  final String url;

  final String? mimeType;

  final String? blurhash;

  final String? dimension;

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

  List<String> toJson() {
    return [
      'imeta',
      'url $url',
      if (mimeType != null) 'm $mimeType',
      if (blurhash != null) 'blurhash $blurhash',
      if (dimension != null) 'dim $dimension',
    ];
  }

  @override
  String toString() {
    return 'MediaAttachment(mediaType: $mediaType, url: $url, '
        'mimeType: $mimeType, blurhash: $blurhash, dimension: $dimension)';
  }
}
