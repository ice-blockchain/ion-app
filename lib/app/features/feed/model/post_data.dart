import 'package:ice/app/extensions/num.dart';

class PostData {
  PostData({
    required this.id,
    required this.body,
    required this.media,
  });

  final String id;

  final String body;

  final Set<PostMedia> media;

  @override
  String toString() => 'PostData(id: $id, body: $body, media: $media)';
}

class PostMedia {
  PostMedia({
    required this.type,
    required this.url,
    this.mime,
    this.blurhash,
    this.dimension,
  }) {
    aspectRatio = _aspectRatioFromDimension(dimension);
  }

  final PostMediaType type;

  final String url;

  final String? mime;

  final String? blurhash;

  final String? dimension;

  late double? aspectRatio;

  /// Calculates the aspect ratio from a given dimension string.
  ///
  /// This method takes a dimension string in the format of "WIDTHxHEIGHT"
  /// and returns the aspect ratio (WIDTH divided by HEIGHT) as a double.
  /// If the input string is null, not in the correct format, or contains
  /// invalid dimensions (e.g., zero or non-numeric values), it returns null.
  double? _aspectRatioFromDimension(String? dimension) {
    if (dimension == null) {
      return null;
    }

    final dimensionRegExp = RegExp(r'(\d+)x(\d+)');

    if (!dimensionRegExp.hasMatch(dimension)) {
      return null;
    }

    final match = dimensionRegExp.firstMatch(dimension);
    final width = double.tryParse(match?.group(0) ?? '0').zeroOrValue;
    final height = double.tryParse(match?.group(1) ?? '0').zeroOrValue;

    return width != 0 && height != 0 ? width / height : null;
  }

  @override
  String toString() {
    return '''
      PostMedia(
        type: $type,
        url: $url,
        mime: $mime,
        blurhash: $blurhash,
        dimension: $dimension,
        aspectRatio: $aspectRatio
      )
    ''';
  }
}

enum PostMediaType { image, video }
