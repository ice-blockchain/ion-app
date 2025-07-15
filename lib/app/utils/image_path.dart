// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

extension ImagePathExtension on String {
  bool get isSvg => toLowerCase().endsWith('.svg');
  bool get isGif => toLowerCase().endsWith('.gif');
  bool get isNetworkSvg {
    final lowerCase = toLowerCase();

    return (lowerCase.startsWith('https://') || lowerCase.startsWith('http://')) && isSvg;
  }
}

Future<bool> isGifAsset(AssetEntity assetEntity) async {
  if (assetEntity.mimeType == 'image/gif') {
    return true;
  }

  final file = await assetEntity.originFile;
  final path = file?.path;
  if (path != null && path.isGif) {
    return true;
  }

  return false;
}

Future<File?> getAssetFile(AssetEntity assetEntity) async {
  if (await isGifAsset(assetEntity)) {
    return assetEntity.originFile;
  } else {
    return assetEntity.file;
  }
}
