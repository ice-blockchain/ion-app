// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/file_storage_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_auth.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_upload_notifier.c.freezed.dart';
part 'nostr_upload_notifier.c.g.dart';

typedef UploadResult = ({FileMetadata fileMetadata, MediaAttachment mediaAttachment});

@riverpod
class NostrUploadNotifier extends _$NostrUploadNotifier {
  @override
  FutureOr<void> build() {}

  Future<UploadResult> upload(
    MediaFile file, {
    required FileAlt alt,
  }) async {
    if (file.width == null || file.height == null) {
      throw UnknownFileResolutionException();
    }

    final dimension = '${file.width}x${file.height}';

    final apiUrl = await _getFileStorageApiUrl();

    final response = await _makeUploadRequest(url: apiUrl, file: file, alt: alt);

    final fileMetadata = FileMetadata.fromUploadResponseTags(
      response.nip94Event.tags,
      mimeType: file.mimeType,
    );

    final mediaAttachment = MediaAttachment(
      url: fileMetadata.url,
      mimeType: fileMetadata.mimeType,
      dimension: dimension,
      torrentInfoHash: fileMetadata.torrentInfoHash,
      fileHash: fileMetadata.fileHash,
      originalFileHash: fileMetadata.originalFileHash,
      alt: alt,
      thumb: fileMetadata.thumb,
    );

    return (fileMetadata: fileMetadata, mediaAttachment: mediaAttachment);
  }

  // TODO: handle delegatedToUrl when migrating to common relays
  Future<String> _getFileStorageApiUrl() async {
    final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetchForCurrentUser();
    if (userRelays == null) {
      throw UserRelaysNotFoundException();
    }
    final relayUrl = userRelays.data.list.random.url;

    try {
      final parsedRelayUrl = Uri.parse(relayUrl);
      final metadataUri = Uri(
        scheme: 'https',
        host: parsedRelayUrl.host,
        port: parsedRelayUrl.hasPort ? parsedRelayUrl.port : null,
        path: FileStorageMetadata.path,
      );

      final response = await ref.read(dioProvider).getUri<dynamic>(metadataUri);
      final uploadPath =
          FileStorageMetadata.fromJson(json.decode(response.data as String) as Map<String, dynamic>)
              .apiUrl;
      return metadataUri.replace(path: uploadPath).toString();
    } catch (error) {
      throw GetFileStorageUrlException(error);
    }
  }

  Future<UploadResponse> _makeUploadRequest({
    required String url,
    required MediaFile file,
    required FileAlt alt,
  }) async {
    final fileBytes = await File(file.path).readAsBytes();
    final fileName = file.name ?? file.basename;
    final multipartFile = MultipartFile.fromBytes(fileBytes, filename: fileName);

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      'caption': fileName,
      'alt': alt.toShortString(),
      'size': multipartFile.length,
      'content_type': file.mimeType,
    });

    final nostrAuth = NostrAuth(url: url, method: 'POST', payload: fileBytes);
    final authEvent = await ref.read(nostrNotifierProvider.notifier).sign(nostrAuth);

    try {
      final response = await ref.read(dioProvider).post<dynamic>(
            url,
            data: formData,
            options: Options(
              headers: {'Authorization': nostrAuth.toAuthorizationHeader(authEvent)},
            ),
          );

      final uploadResponse =
          UploadResponse.fromJson(json.decode(response.data as String) as Map<String, dynamic>);

      if (uploadResponse.status != 'success') {
        throw Exception(uploadResponse.message);
      }

      return uploadResponse;
    } catch (error) {
      throw FileUploadException(error, url: url);
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
