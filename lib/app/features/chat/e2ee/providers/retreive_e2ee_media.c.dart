// //   // Works in progress with https://pub.dev/packages/flutter_cache_manager
// //   Future<List<File>> downloadDecryptDecompressMedia(List<MediaAttachment> mediaAttachments) async {
// //     final decryptedDecompressedFiles = <File>[];

// //     for (final attachment in mediaAttachments) {
// //       if (attachment.encryptionKey != null &&
// //           attachment.encryptionNonce != null &&
// //           attachment.encryptionMac != null) {
// //         final mac = base64Decode(attachment.encryptionMac!);
// //         final nonce = base64Decode(attachment.encryptionNonce!);
// //         final secretKey = base64Decode(attachment.encryptionKey!);

// //         final file = await fileCacheService.getFile(attachment.url);

// //         final fileBytes = await file.readAsBytes();

// //         final secretBox = SecretBox(
// //           fileBytes,
// //           nonce: nonce,
// //           mac: Mac(mac),
// //         );
// //         // Wrong Mac authentication error described here
// //         // https://github.com/dint-dev/cryptography/issues/147
// //         final decryptedFileBytesList = await AesGcm.with256bits().decrypt(
// //           secretBox,
// //           secretKey: SecretKey(secretKey),
// //         );

// //         final decryptedFileBytes = Uint8List.fromList(decryptedFileBytesList);

// //         final decryptedFile = await fileCacheService.putFile(
// //           url: file.path,
// //           bytes: decryptedFileBytes,
// //           fileExtension: attachment.mimeType.split('/').last,
// //         );

// //         if (attachment.mediaType == MediaType.unknown) {
// //           final decompressedFile = await compressionService.decompressBrotli(file);

// //           decryptedDecompressedFiles.add(decompressedFile);
// //         } else {
// //           decryptedDecompressedFiles.add(decryptedFile);
// //         }
// //       }
// //     }
// //     return decryptedDecompressedFiles;
// //   }

// @riverpod
// class RetrieveE2eeMedia extends _$RetrieveE2eeMedia {
//   @override
//   Future<List<File>> build() async {
//     return [];
//   }
// }
