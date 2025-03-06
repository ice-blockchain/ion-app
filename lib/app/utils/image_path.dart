extension ImagePathExtension on String {
  bool get isSvg => toLowerCase().endsWith('.svg');
}
