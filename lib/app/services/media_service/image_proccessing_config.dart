// SPDX-License-Identifier: ice License 1.0

import 'package:image_cropper/image_cropper.dart';

class CropImageConfig {
  const CropImageConfig({
    required this.aspectRatio,
    required this.targetWidth,
    required this.targetHeight,
    this.quality = 70,
  });

  final CropAspectRatio aspectRatio;
  final int targetWidth;
  final int targetHeight;
  final int quality;
}

class ImageProcessingConstants {
  ImageProcessingConstants._();

  static const avatar = CropImageConfig(
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    targetWidth: 720,
    targetHeight: 720,
  );

  static const banner = CropImageConfig(
    aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
    targetWidth: 1024,
    targetHeight: 768,
  );

  static const articleCover = CropImageConfig(
    aspectRatio: CropAspectRatio(ratioX: 343, ratioY: 210),
    targetWidth: 1024,
    targetHeight: 627,
  );
}

enum ImageProcessingType {
  avatar,
  banner,
  articleCover;

  CropImageConfig get config => switch (this) {
        ImageProcessingType.avatar => ImageProcessingConstants.avatar,
        ImageProcessingType.banner => ImageProcessingConstants.banner,
        ImageProcessingType.articleCover => ImageProcessingConstants.articleCover,
      };
}
