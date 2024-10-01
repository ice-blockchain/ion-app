// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/core/model/media_type.dart';

class PostMediaData {
  PostMediaData({
    required this.mediaType,
    required this.url,
    this.mimeType,
    this.blurhash,
    this.dimension,
  }) {
    aspectRatio = _aspectRatioFromDimension(dimension);
  }

  final MediaType mediaType;

  final String url;

  final String? mimeType;

  final String? blurhash;

  final String? dimension;

  late double? aspectRatio;

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

  @override
  String toString() {
    return 'PostMediaData(mediaType: $mediaType, url: $url, '
        'mimeType: $mimeType, blurhash: $blurhash, dimension: $dimension)';
  }
}
