// SPDX-License-Identifier: ice License 1.0

import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_compress_service.g.dart';

abstract class IPhotoCompressService {
  Future<XFile> compressImage(XFile file, {int quality});

  String generateCompressedFilePath(String filePath) {
    final fileName = filePath.split('/').last;
    final directory = filePath.substring(0, filePath.lastIndexOf('/'));

    if (fileName.contains('.')) {
      final extension = fileName.split('.').last;
      final nameWithoutExtension = fileName.substring(0, fileName.lastIndexOf('.'));
      return '$directory/${nameWithoutExtension}_compressed.$extension';
    } else {
      return '$directory/${fileName}_compressed';
    }
  }
}

class PhotoCompressService extends IPhotoCompressService {
  @override
  Future<XFile> compressImage(XFile file, {int quality = 80}) async {
    final config = ImageFileConfiguration(
      input: ImageFile(
        filePath: file.path,
        rawBytes: await file.readAsBytes(),
      ),
      config: Configuration(
        quality: quality,
      ),
    );

    final output = await compressor.compress(config);

    final newPath = generateCompressedFilePath(file.path);

    final compressedFile = XFile.fromData(output.rawBytes);

    await compressedFile.saveTo(newPath);

    return XFile(newPath);
  }
}

@riverpod
IPhotoCompressService photoCompressService(PhotoCompressServiceRef ref) => PhotoCompressService();
