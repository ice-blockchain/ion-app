// SPDX-License-Identifier: ice License 1.0

enum MediaType {
  image,
  video,
  unknown;

  factory MediaType.fromMimeType(String mimeType) {
    final imageRegex = RegExp('^image/');
    final videoRegex = RegExp('^video/');
    if (imageRegex.hasMatch(mimeType)) {
      return MediaType.image;
    } else if (videoRegex.hasMatch(mimeType)) {
      return MediaType.video;
    }
    return MediaType.unknown;
  }

  factory MediaType.fromUrl(String url) {
    if (isImageUrl(url)) {
      return MediaType.image;
    } else if (isVideoUrl(url)) {
      return MediaType.video;
    } else {
      return MediaType.unknown;
    }
  }

  static bool isImageUrl(String url) {
    return RegExp(r'https?://\S+\.(?:jpg|jpeg|png|gif|bmp|svg|webp)').hasMatch(url);
  }

  static bool isVideoUrl(String url) {
    return RegExp(r'https?://\S+\.(?:mp4|avi|mov|wmv|flv|mkv|webm)').hasMatch(url);
  }
}
