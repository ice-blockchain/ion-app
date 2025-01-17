// SPDX-License-Identifier: ice License 1.0

import 'package:image_cropper/image_cropper.dart';

class ArticleConstants {
  ArticleConstants._();

  static double get headerImageAspectRation => 343 / 210;

  static const cropAspectRatio = CropAspectRatio(
    ratioX: 343,
    ratioY: 210,
  );

  static const compressedImageWidth = 1024;
  static const compressedImageHeight = 627;
}
