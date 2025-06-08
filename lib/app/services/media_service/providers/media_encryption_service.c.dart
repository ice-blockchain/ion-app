// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/data/models/media_type.dart';
import 'package:ion/app/features/core/providers/ion_connect_media_url_fallback_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';
import 'package:ion/app/services/media_service/data/models/encrypted_media_file.c.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/app/services/providers/compressors/brotli_compressor.c.dart';
import 'package:ion/app/services/providers/file_cache/ion_file_cache_manager.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_encryption_service.c.g.dart';

class MediaEncryptionService {
  MediaEncryptionService({
    required this.fileCacheService,
    required this.brotliCompressor,
    required this.generateMediaUrlFallback,
  });

  final FileCacheService fileCacheService;
  final BrotliCompressor brotliCompressor;
  final Future<String?> Function(String url, {required String authorPubkey})
      generateMediaUrlFallback;

  Future<File> retrieveEncryptedMedia(
    MediaAttachment attachment, {
    required String authorPubkey,
  }) async {
    try {
      if (attachment.encryptionKey != null &&
          attachment.encryptionNonce != null &&
          attachment.encryptionMac != null) {
        final url = attachment.url;
        final mac = base64Decode(attachment.encryptionMac!);
        final nonce = base64Decode(attachment.encryptionNonce!);
        final secretKey = base64Decode(attachment.encryptionKey!);

        final cacheFileInfo = await fileCacheService.getFileFromCache(url);

        if (cacheFileInfo != null) {
          return cacheFileInfo.file;
        }

        final file = await _downloadFile(url, authorPubkey: authorPubkey);

        final fileBytes = await compute(
          (file) {
            return file.readAsBytes();
          },
          file,
        );

        final secretBox = SecretBox(
          fileBytes,
          nonce: nonce,
          mac: Mac(mac),
        );
        // Wrong Mac authentication error described here
        // https://github.com/dint-dev/cryptography/issues/147
        final decryptedFileBytesList = await AesGcm.with256bits().decrypt(
          secretBox,
          secretKey: SecretKey(secretKey),
        );

        final decryptedFileBytes = Uint8List.fromList(decryptedFileBytesList);

        final fileExtension = attachment.mimeType.split('/').last;

        //remove the file from storage
        await file.delete();
        await fileCacheService.removeFile(url);

        if (attachment.mediaType == MediaType.unknown) {
          final decompressedFile = await brotliCompressor.decompress(decryptedFileBytes);

          final decryptedFile = await fileCacheService.putFile(
            url: url,
            bytes: decompressedFile.readAsBytesSync(),
            fileExtension: fileExtension,
          );

          return decryptedFile;
        } else {
          final decryptedFile = await fileCacheService.putFile(
            url: url,
            bytes: decryptedFileBytes,
            fileExtension: fileExtension,
          );
          return decryptedFile;
        }
      } else {
        throw FailedToDecryptFileException();
      }
    } catch (e) {
      throw FailedToDecryptFileException();
    }
  }

  Future<List<EncryptedMediaFile>> encryptMediaFiles(
    List<MediaFile> compressedMediaFiles,
  ) async {
    final encryptedFiles = <EncryptedMediaFile>[];

    for (final compressedMediaFile in compressedMediaFiles) {
      final encryptedMediaFile = await encryptMediaFile(compressedMediaFile);

      encryptedFiles.add(encryptedMediaFile);
    }

    return encryptedFiles;
  }

  Future<EncryptedMediaFile> encryptMediaFile(
    MediaFile mediaFile,
  ) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final encryptedFiles = <File>[];

    try {
      final encryptedMediaFile = await Isolate.run<EncryptedMediaFile>(() async {
        final secretKey = await AesGcm.with256bits().newSecretKey();
        final secretKeyBytes = await secretKey.extractBytes();
        final secretKeyString = base64Encode(secretKeyBytes);

        final compressedMediaFileBytes = await File(mediaFile.path).readAsBytes();

        final secretBox = await AesGcm.with256bits().encrypt(
          compressedMediaFileBytes,
          secretKey: secretKey,
        );

        final nonceBytes = secretBox.nonce;
        final nonceString = base64Encode(nonceBytes);
        final macString = base64Encode(secretBox.mac.bytes);

        final compressedEncryptedFile =
            File('${documentsDir.path}/${compressedMediaFileBytes.hashCode}.enc');

        await compressedEncryptedFile.writeAsBytes(secretBox.cipherText);

        encryptedFiles.add(compressedEncryptedFile);

        final compressedEncryptedMediaFile = MediaFile(
          path: compressedEncryptedFile.path,
          width: mediaFile.width,
          height: mediaFile.height,
          mimeType: mediaFile.mimeType,
          duration: mediaFile.duration,
        );

        return EncryptedMediaFile(
          mediaFile: compressedEncryptedMediaFile,
          secretKey: secretKeyString,
          nonce: nonceString,
          mac: macString,
        );
      });

      return encryptedMediaFile;
    } catch (e) {
      for (final file in encryptedFiles) {
        await file.delete();
      }
      rethrow;
    }
  }

  Future<File> _downloadFile(
    String url, {
    required String authorPubkey,
    bool withFallback = true,
  }) async {
    try {
      return await fileCacheService.getFile(url);
    } catch (error) {
      if (!withFallback) {
        rethrow;
      }

      final fallbackUrl = await generateMediaUrlFallback(url, authorPubkey: authorPubkey);

      if (fallbackUrl == null) {
        throw FailedToGenerateMediaUrlFallback();
      }

      return _downloadFile(fallbackUrl, authorPubkey: authorPubkey, withFallback: false);
    }
  }
}

@riverpod
MediaEncryptionService mediaEncryptionService(Ref ref) => MediaEncryptionService(
      fileCacheService: ref.read(fileCacheServiceProvider),
      brotliCompressor: ref.read(brotliCompressorProvider),
      generateMediaUrlFallback:
          ref.read(iONConnectMediaUrlFallbackProvider.notifier).generateFallback,
    );
