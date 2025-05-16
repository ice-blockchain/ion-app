// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:es_compression/brotli.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/compressors/compressor.c.dart';
import 'package:ion/app/services/compressors/output_path_generator.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brotli_compressor.c.g.dart';

class BrotliCompressionSettings {
  const BrotliCompressionSettings({
    this.quality = 11,
  });

  final int quality;
}

class BrotliCompressor implements Compressor<BrotliCompressionSettings> {
  final _brotliCodec = BrotliCodec();

  ///
  /// Compresses a file using the Brotli algorithm.
  ///
  @override
  Future<MediaFile> compress(MediaFile file, {BrotliCompressionSettings? settings}) async {
    try {
      final inputData = await File(file.path).readAsBytes();
      final compressedData = await compute(_brotliCodec.encode, inputData);
      return _saveBytesIntoFile(bytes: compressedData, extension: 'br');
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli compression!', error: error, stackTrace: stackTrace);
      throw CompressWithBrotliException();
    }
  }

  ///
  /// Decompresses a Brotli-compressed file.
  ///
  Future<File> decompress(List<int> compressedData, {String outputExtension = ''}) async {
    try {
      final decompressedData = _brotliCodec.decode(compressedData);
      final outputFile =
          await _saveBytesIntoFile(bytes: decompressedData, extension: outputExtension);

      return File(outputFile.path);
    } catch (error, stackTrace) {
      Logger.log('Error during Brotli decompression!', error: error, stackTrace: stackTrace);
      throw DecompressBrotliException();
    }
  }

  Future<MediaFile> _saveBytesIntoFile({
    required List<int> bytes,
    required String extension,
  }) async {
    final outputFilePath = await generateOutputPath(extension: extension);
    final outputFile = File(outputFilePath);
    await outputFile.writeAsBytes(bytes);

    return MediaFile(
      path: outputFilePath,
      mimeType: 'application/brotli',
      width: 0,
      height: 0,
    );
  }
}

@Riverpod(keepAlive: true)
BrotliCompressor brotliCompressor(Ref ref) => BrotliCompressor();
