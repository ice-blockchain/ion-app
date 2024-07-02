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
    final imageRegex = RegExp(r'\.(jpg|jpeg|png|gif|bmp|tiff|webp)$');
    final videoRegex = RegExp(r'\.(mp4|avi|mov|wmv|flv|mkv|webm)$');
    if (imageRegex.hasMatch(url)) {
      return MediaType.image;
    } else if (videoRegex.hasMatch(url)) {
      return MediaType.video;
    } else {
      return MediaType.unknown;
    }
  }
}
