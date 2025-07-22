// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/utils/url.dart';
import 'package:photo_manager/photo_manager.dart';

extension ImagePathExtension on String {
  bool get isSvg => toLowerCase().endsWith('.svg');
  bool get isGif => toLowerCase().endsWith('.gif');
  bool get isNetworkSvg => isNetworkUrl(toLowerCase()) && isSvg;
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

Future<bool> isAnimatedAsset(AssetEntity assetEntity) async {
  final isGif = await isGifAsset(assetEntity);
  if (isGif) {
    return true;
  }

  if (assetEntity.mimeType == 'image/webp') {
    return true;
  }

  final file = await assetEntity.originFile;
  final path = file?.path;

  if (path != null && path.toLowerCase().endsWith('.webp')) {
    return true;
  }

  return false;
}

Future<File?> getAssetFile(AssetEntity assetEntity) async {
  final isAnimated = await isAnimatedAsset(assetEntity);

  File? resultFile;
  if (isAnimated) {
    resultFile = await assetEntity.originFile;
  } else {
    resultFile = await assetEntity.file;
  }

  return resultFile;
}
