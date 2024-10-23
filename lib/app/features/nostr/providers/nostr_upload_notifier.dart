// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
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

  Future<void> upload(
    MediaFile file,
  ) async {
    final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);

    if (keyStore == null) {
      throw Exception('Current user key store is null');
    }

    final apiUrl = await _getFileStorageApiUrl(keyStore: keyStore);

    final response = await _makeUploadRequest(url: apiUrl, file: file, keyStore: keyStore);

    final fileMetadata = FileMetadata.fromUploadResponseTags(
      response.nip94Event['tags'] as List<List<String>>,
      mimeType: file.mimeType,
    );

    await ref.read(nostrNotifierProvider.notifier).sendOne(fileMetadata.toEventMessage(keyStore));
  }

  Future<String> _getFileStorageApiUrl({required KeyStore keyStore}) async {
    final userRelays =
        await ref.read(nostrNotifierProvider.notifier).getUserRelays(keyStore.publicKey);

    var metadataUri = Uri.https(userRelays.list.random.url, FileStorageMetadata.path);

    // TODO: should we limit redirects count?
    while (true) {
      final response = await ref.read(dioProvider).getUri<FileStorageMetadata>(metadataUri);

      final apiUrl = response.data?.apiUrl ?? '';

      if (apiUrl.isNotEmpty) {
        return apiUrl;
      }

      final delegatedToUrl = response.data?.delegatedToUrl ?? '';

      if (delegatedToUrl.isEmpty) {
        throw Exception('Both api_url and delegated_to_url are empty');
      }

      metadataUri = Uri.https(delegatedToUrl, FileStorageMetadata.path);
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

    final nostrAuth = NostrAuth(
      url: url,
      method: 'POST',
      payload: fileBytes,
    );

    try {
      final response = await ref.read(dioProvider).post<UploadResponse>(
            url,
            data: formData,
            options: Options(
              headers: {'Authorization': await nostrAuth.toAuthorizationHeader(keyStore)},
            ),
          );

      final data = response.data;

      if (data == null) {
        throw Exception('response data is null');
      }

      if (data.status != 'success') {
        throw Exception(data.message);
      }

      return data;
    } catch (error) {
      throw Exception('Failed to upload file: $error');
    }
  }
}

@freezed
class UploadResponse with _$UploadResponse {
  const factory UploadResponse({
    required String status,
    required String message,
    @JsonKey(name: 'nip94_event') required Map<String, dynamic> nip94Event,
  }) = _UploadResponse;
}
