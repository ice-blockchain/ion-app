// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/media_attachment.dart';
import 'package:ion/app/features/core/providers/dio_provider.dart';
import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/file_storage_metadata.dart';
import 'package:ion/app/features/nostr/model/nostr_auth.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_upload_notifier.g.dart';
part 'nostr_upload_notifier.freezed.dart';

@riverpod
class NostrUploadNotifier extends _$NostrUploadNotifier {
  @override
  FutureOr<void> build() {}

  Future<MediaAttachment> upload(
    MediaFile file,
  ) async {
    final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);

    if (keyStore == null) {
      throw Exception('Current user key store is null');
    }

    final apiUrl = await _getFileStorageApiUrl(keyStore: keyStore);

    final response = await _makeUploadRequest(url: apiUrl, file: file, keyStore: keyStore);

    final fileMetadata = FileMetadata.fromUploadResponseTags(
      response.nip94Event.tags,
      mimeType: file.mimeType,
    );

    await ref.read(nostrNotifierProvider.notifier).sendOne(fileMetadata.toEventMessage(keyStore));

    return MediaAttachment(
      url: fileMetadata.url,
      mimeType: fileMetadata.mimeType,
      blurhash: fileMetadata.blurhash,
      dimension: fileMetadata.dimension,
    );
  }

  // TODO: handle delegatedToUrl when migrating to common relays
  Future<String> _getFileStorageApiUrl({required KeyStore keyStore}) async {
    //TODO: switch to userRelays.list.random.url when using our relays
    // final userRelays =
    //     await ref.read(nostrNotifierProvider.notifier).getUserRelays(keyStore.publicKey);
    const relayUrl = /*userRelays.list.random.url*/ 'wss://nostr.build';

    try {
      final metadataUri =
          Uri.parse(relayUrl).replace(scheme: 'https', path: FileStorageMetadata.path);
      final response = await ref.read(dioProvider).getUri<Map<String, dynamic>>(metadataUri);
      return FileStorageMetadata.fromJson(response.data!).apiUrl;
    } catch (error) {
      throw Exception('Failed to get file storage url $error');
    }
  }

  Future<UploadResponse> _makeUploadRequest({
    required String url,
    required MediaFile file,
    required KeyStore keyStore,
  }) async {
    final fileBytes = await File(file.path).readAsBytes();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: file.name),
      'caption': file.name,
      'alt': file.name,
      'size': file.size,
      'content_type': file.mimeType,
    });

    final nostrAuth = NostrAuth(url: url, method: 'POST', payload: fileBytes);

    try {
      final response = await ref.read(dioProvider).post<Map<String, dynamic>>(
            url,
            data: formData,
            options: Options(
              headers: {'Authorization': await nostrAuth.toAuthorizationHeader(keyStore)},
            ),
          );

      final uploadResponse = UploadResponse.fromJson(response.data!);

      if (uploadResponse.status != 'success') {
        throw Exception(uploadResponse.message);
      }

      return uploadResponse;
    } catch (error) {
      throw Exception('Failed to upload file to $url: $error');
    }
  }
}

@freezed
class UploadResponse with _$UploadResponse {
  const factory UploadResponse({
    required String status,
    required String message,
    @JsonKey(name: 'nip94_event') required UploadResponseNip94Event nip94Event,
  }) = _UploadResponse;

  factory UploadResponse.fromJson(Map<String, dynamic> json) => _$UploadResponseFromJson(json);
}

@freezed
class UploadResponseNip94Event with _$UploadResponseNip94Event {
  const factory UploadResponseNip94Event({
    required String content,
    required List<List<String>> tags,
  }) = _UploadResponseNip94Event;

  factory UploadResponseNip94Event.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseNip94EventFromJson(json);
}
