// SPDX-License-Identifier: ice License 1.0

// // SPDX-License-Identifier: ice License 1.0

// import 'dart:convert';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:typed_data';

// import 'package:cryptography/cryptography.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ion/app/exceptions/exceptions.dart';
// import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
// import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
// import 'package:ion/app/features/core/model/media_type.dart';
// import 'package:ion/app/features/core/providers/env_provider.c.dart';
// import 'package:ion/app/features/ion_connect/ion_connect.dart';
// import 'package:ion/app/features/ion_connect/model/action_source.dart';
// import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
// import 'package:ion/app/features/ion_connect/model/file_alt.dart';
// import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
// import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
// import 'package:ion/app/services/compressor/compress_service.c.dart';
// import 'package:ion/app/services/file_cache/ion_file_cache_manager.c.dart';
// import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
// import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
// import 'package:ion/app/services/media_service/media_service.c.dart';
// import 'package:ion/app/services/uuid/uuid.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'conversation_message_management_provider.c.g.dart';

// @Riverpod(keepAlive: true)
// Future<ConversationMessageManagementService> conversationMessageManagementService(
//   Ref ref,
// ) async {
//   final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

//   return ConversationMessageManagementService(
//     eventSigner: eventSigner,
//     env: ref.watch(envProvider.notifier),
//     fileCacheService: ref.watch(fileCacheServiceProvider),
//     compressionService: ref.watch(compressServiceProvider),
//     sealService: await ref.watch(ionConnectSealServiceProvider.future),
//     ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
//     wrapService: await ref.watch(ionConnectGiftWrapServiceProvider.future),
//     ionConnectUploadNotifier: ref.watch(ionConnectUploadNotifierProvider.notifier),
//   );
// }

// class ConversationMessageManagementService {
//   ConversationMessageManagementService({
//     required this.env,
//     required this.wrapService,
//     required this.sealService,
//     required this.eventSigner,
//     required this.ionConnectNotifier,
//     required this.fileCacheService,
//     required this.ionConnectUploadNotifier,
//     required this.compressionService,
//   });

//   final Env env;
//   final EventSigner? eventSigner;
//   final IonConnectNotifier ionConnectNotifier;
//   final FileCacheService fileCacheService;
//   final IonConnectSealService sealService;
//   final IonConnectGiftWrapService wrapService;
//   final CompressionService compressionService;
//   final IonConnectUploadNotifier ionConnectUploadNotifier;

//   Future<List<IonConnectEntity?>> sentMessage({
//     required String content,
//     required List<String> participantsPubkeys,
//     String? subject,
//     String? conversationUuid,
//     List<MediaFile> mediaFiles = const [],
//   }) async {
//     if (eventSigner == null) {
//       throw EventSignerNotFoundException();
//     }

//     final conversationTags = _generateConversationTags(
//       subject: subject,
//       pubkeys: participantsPubkeys,
//       conversationUuid: conversationUuid,
//     );

//     if (mediaFiles.isNotEmpty) {
//       final compressedMediaFiles = await _compressMediaFiles(mediaFiles);

//       final results = await Future.wait(
//         participantsPubkeys.map((participantPubkey) async {
//           final encryptedMediaFiles = await _encryptMediaFiles(compressedMediaFiles);

//           final uploadedMediaFilesWithKeys = await Future.wait(
//             encryptedMediaFiles.map((encryptedMediaFile) async {
//               final mediaFile = encryptedMediaFile.$1;
//               final secretKey = encryptedMediaFile.$2;
//               final nonce = encryptedMediaFile.$3;
//               final mac = encryptedMediaFile.$4;

//               final uploadResult = await ionConnectUploadNotifier.upload(
//                 mediaFile,
//                 alt: FileAlt.message,
//               );

//               return (uploadResult, secretKey, nonce, mac);
//             }),
//           );

//           for (final mediaFile in encryptedMediaFiles) {
//             final file = File(mediaFile.$1.path);
//             await file.delete();
//           }

//           final imetaTags = _generateImetaTags(uploadedMediaFilesWithKeys);

//           final tags = conversationTags..addAll(imetaTags);

//           final giftWrap = await _createGiftWrap(
//             tags: tags,
//             content: content,
//             signer: eventSigner!,
//             receiverPubkey: participantPubkey,
//           );

//           return _sendGiftWrap(giftWrap, pubkey: participantPubkey);
//         }),
//       );

//       for (final mediaFile in compressedMediaFiles) {
//         final file = File(mediaFile.path);
//         await file.delete();
//       }

//       return results;
//     } else {
//       // Send copy of the message to each participant
//       final results = await Future.wait(
//         participantsPubkeys.map((participantPubkey) async {
//           final giftWrap = await _createGiftWrap(
//             content: content,
//             signer: eventSigner!,
//             tags: conversationTags,
//             receiverPubkey: participantPubkey,
//           );

//           return _sendGiftWrap(giftWrap, pubkey: participantPubkey);
//         }).toList(),
//       );

//       return results;
//     }
//   }

//   // Works in progress with https://pub.dev/packages/flutter_cache_manager
//   Future<List<File>> downloadDecryptDecompressMedia(List<MediaAttachment> mediaAttachments) async {
//     final decryptedDecompressedFiles = <File>[];

//     for (final attachment in mediaAttachments) {
//       if (attachment.encryptionKey != null &&
//           attachment.encryptionNonce != null &&
//           attachment.encryptionMac != null) {
//         final mac = base64Decode(attachment.encryptionMac!);
//         final nonce = base64Decode(attachment.encryptionNonce!);
//         final secretKey = base64Decode(attachment.encryptionKey!);

//         final file = await fileCacheService.getFile(attachment.url);

//         final fileBytes = await file.readAsBytes();

//         final secretBox = SecretBox(
//           fileBytes,
//           nonce: nonce,
//           mac: Mac(mac),
//         );
//         // Wrong Mac authentication error described here
//         // https://github.com/dint-dev/cryptography/issues/147
//         final decryptedFileBytesList = await AesGcm.with256bits().decrypt(
//           secretBox,
//           secretKey: SecretKey(secretKey),
//         );

//         final decryptedFileBytes = Uint8List.fromList(decryptedFileBytesList);

//         final decryptedFile = await fileCacheService.putFile(
//           url: file.path,
//           bytes: decryptedFileBytes,
//           fileExtension: attachment.mimeType.split('/').last,
//         );

//         if (attachment.mediaType == MediaType.unknown) {
//           final decompressedFile = await compressionService.decompressBrotli(file);

//           decryptedDecompressedFiles.add(decompressedFile);
//         } else {
//           decryptedDecompressedFiles.add(decryptedFile);
//         }
//       }
//     }
//     return decryptedDecompressedFiles;
//   }

//   List<List<String>> _generateConversationTags({
//     required List<String> pubkeys,
//     String? subject,
//     String? conversationUuid,
//   }) {
//     final tags = [
//       if (subject != null && pubkeys.length > 1) ['subject', subject],
//       ...pubkeys.map((pubkey) => ['p', pubkey]),
//       CommunityIdentifierTag(value: conversationUuid ?? generateUuid()).toTag(),
//     ];

//     return tags;
//   }

//   Future<EventMessage> _createGiftWrap({
//     required String content,
//     required String receiverPubkey,
//     required EventSigner signer,
//     required List<List<String>> tags,
//   }) async {
//     final createdAt = DateTime.now().toUtc();

//     final id = EventMessage.calculateEventId(
//       tags: tags,
//       content: content,
//       createdAt: createdAt,
//       publicKey: signer.publicKey,
//       kind: PrivateDirectMessageEntity.kind,
//     );

//     final eventMessage = EventMessage(
//       id: id,
//       tags: tags,
//       content: content,
//       createdAt: createdAt,
//       pubkey: signer.publicKey,
//       kind: PrivateDirectMessageEntity.kind,
//       sig: null,
//     );

//     final expirationTag = EntityExpiration(
//       value: DateTime.now().add(
//         // TODO:  Create GIFT_WRAP_EXPIRATION_TIME env variable
//         Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
//       ),
//     ).toTag();

//     final seal = await sealService.createSeal(
//       eventMessage,
//       signer,
//       receiverPubkey,
//     );

//     final wrap = await wrapService.createWrap(
//       seal,
//       receiverPubkey,
//       PrivateDirectMessageEntity.kind,
//       expirationTag: expirationTag,
//     );

//     return wrap;
//   }

//   Future<IonConnectEntity?> _sendGiftWrap(EventMessage giftWrap, {required String pubkey}) async {
//     return ionConnectNotifier.sendEvent(
//       giftWrap,
//       cache: false,
//       actionSource: ActionSourceUserChat(pubkey, anonymous: true),
//     );
//   }

//   Future<List<MediaFile>> _compressMediaFiles(
//     List<MediaFile> mediaFiles,
//   ) async {
//     // Would be better to compress all media files in isolates when this one is
//     // fixed https://github.com/arthenica/ffmpeg-kit/issues/367
//     final compressedMediaFiles = await Future.wait(
//       mediaFiles.map(
//         (mediaFile) async {
//           final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

//           final compressedMediaFile = switch (mediaType) {
//             MediaType.video => await compressionService.compressVideo(mediaFile),
//             MediaType.image => await compressionService.compressImage(
//                 mediaFile,
//                 width: mediaFile.width,
//                 height: mediaFile.height,
//               ),
//             MediaType.audio => MediaFile(
//                 width: 0,
//                 height: 0,
//                 mimeType: mediaFile.mimeType,
//                 path: await compressionService.compressAudio(mediaFile.path),
//               ),
//             MediaType.unknown => MediaFile(
//                 path: (await compressionService.compressWithBrotli(File(mediaFile.path))).path,
//               )
//           };

//           return compressedMediaFile;
//         },
//       ).toList(),
//     );

//     return compressedMediaFiles;
//   }

//   Future<List<(MediaFile, String, String, String)>> _encryptMediaFiles(
//     List<MediaFile> compressedMediaFiles,
//   ) async {
//     final documentsDir = await getApplicationDocumentsDirectory();
//     final encryptedMediaFiles = await Future.wait(
//       compressedMediaFiles.map(
//         (compressedMediaFile) => Isolate.run<(MediaFile, String, String, String)>(() async {
//           final secretKey = await AesGcm.with256bits().newSecretKey();
//           final secretKeyBytes = await secretKey.extractBytes();
//           final secretKeyString = base64Encode(secretKeyBytes);

//           final compressedMediaFileBytes = await File(compressedMediaFile.path).readAsBytes();

//           final secretBox = await AesGcm.with256bits().encrypt(
//             compressedMediaFileBytes,
//             secretKey: secretKey,
//           );

//           final nonceBytes = secretBox.nonce;
//           final nonceString = base64Encode(nonceBytes);
//           final macString = base64Encode(secretBox.mac.bytes);

//           final compressedEncryptedFile =
//               File('${documentsDir.path}/${compressedMediaFileBytes.hashCode}.enc');

//           await compressedEncryptedFile.writeAsBytes(secretBox.cipherText);

//           final compressedEncryptedMediaFile = MediaFile(
//             path: compressedEncryptedFile.path,
//             width: compressedMediaFile.width,
//             height: compressedMediaFile.height,
//             mimeType: compressedMediaFile.mimeType,
//           );

//           return (
//             compressedEncryptedMediaFile,
//             secretKeyString,
//             nonceString,
//             macString,
//           );
//         }),
//       ),
//     );

//     return encryptedMediaFiles;
//   }

//   List<List<String>> _generateImetaTags(
//     List<(UploadResult, String, String, String)> uploadResults,
//   ) {
//     final expiration = EntityExpiration(
//       value: DateTime.now().add(
//         Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
//       ),
//     );

//     return uploadResults.map((uploadResult) {
//       final fileMetadata = uploadResult.$1.fileMetadata;

//       final secretKey = uploadResult.$2;
//       final nonce = uploadResult.$3;
//       final mac = uploadResult.$4;

//       return [
//         'imeta',
//         'url ${fileMetadata.url}',
//         'alt ${fileMetadata.alt}',
//         'm ${fileMetadata.mimeType}',
//         'dim ${fileMetadata.dimension}',
//         'x ${fileMetadata.fileHash}',
//         'ox ${fileMetadata.originalFileHash}',
//         'expiration ${expiration.value.millisecondsSinceEpoch ~/ 1000}',
//         'encryption-key $secretKey $nonce $mac aes-gcm',
//       ];
//     }).toList();
//   }
// }
