mixin ImageUtils {
  static String getAdaptiveImageUrl(String imageUrl, double imageWidth) {
    return '$imageUrl?width=${imageWidth.toInt()}';
  }
}
