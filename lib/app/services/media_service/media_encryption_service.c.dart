// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/file_cache/ion_file_cache_manager.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_encryption_service.c.g.dart';

class MediaEncryptionService {
  MediaEncryptionService({
    required this.fileCacheService,
    required this.compressionService,
  });

  final FileCacheService fileCacheService;
  final CompressionService compressionService;

  Future<List<File>> retrieveEncryptedMedia(List<MediaAttachment> mediaAttachments) async {
    final decryptedDecompressedFiles = <File>[];

    try {
      for (final attachment in mediaAttachments) {
        if (attachment.encryptionKey == null ||
            attachment.encryptionNonce == null ||
            attachment.encryptionMac == null) {
          continue;
        }

        final mac = base64Decode(attachment.encryptionMac!);
        final nonce = base64Decode(attachment.encryptionNonce!);
        final secretKey = base64Decode(attachment.encryptionKey!);

        final file = await fileCacheService.getFile(attachment.url);

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

        final decryptedFile = await fileCacheService.putFile(
          url: file.path,
          bytes: decryptedFileBytes,
          fileExtension: attachment.mimeType.split('/').last,
        );

        if (attachment.mediaType == MediaType.unknown) {
          final decompressedFile = await compressionService.decompressBrotli(decryptedFile);

          decryptedDecompressedFiles.add(decompressedFile);
        } else {
          decryptedDecompressedFiles.add(decryptedFile);
        }
      }
    } catch (e) {
      throw FailedToDecryptFileException();
    }

    return decryptedDecompressedFiles;
  }

  Future<List<(MediaFile, String, String, String)>> encryptMediaFiles(
    List<MediaFile> compressedMediaFiles,
  ) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final encryptedFiles = <File>[];

    try {
      final encryptedMediaFiles = await Future.wait(
        compressedMediaFiles.map(
          (compressedMediaFile) => Isolate.run<(MediaFile, String, String, String)>(() async {
            final secretKey = await AesGcm.with256bits().newSecretKey();
            final secretKeyBytes = await secretKey.extractBytes();
            final secretKeyString = base64Encode(secretKeyBytes);

            final compressedMediaFileBytes = await File(compressedMediaFile.path).readAsBytes();

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
              width: compressedMediaFile.width,
              height: compressedMediaFile.height,
              mimeType: compressedMediaFile.mimeType,
            );

            return (
              compressedEncryptedMediaFile,
              secretKeyString,
              nonceString,
              macString,
            );
          }),
        ),
      );

      return encryptedMediaFiles;
    } catch (e) {
      for (final file in encryptedFiles) {
        await file.delete();
      }
      rethrow;
    }
  }
}

@riverpod
MediaEncryptionService mediaEncryptionService(Ref ref) => MediaEncryptionService(
      fileCacheService: ref.read(fileCacheServiceProvider),
      compressionService: ref.read(compressServiceProvider),
    );
