// SPDX-License-Identifier: ice License 1.0

extension ImagePathExtension on String {
  bool get isSvg => toLowerCase().endsWith('.svg');
}
