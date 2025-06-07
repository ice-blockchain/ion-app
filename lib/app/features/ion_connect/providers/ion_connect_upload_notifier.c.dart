// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_upload_models.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/file_storage_url_provider.c.dart';
import 'package:ion/app/features/ion_connect/utils/file_storage_utils.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_upload_notifier.c.g.dart';

typedef UploadResult = ({FileMetadata fileMetadata, MediaAttachment mediaAttachment});

@riverpod
class IonConnectUploadNotifier extends _$IonConnectUploadNotifier {
  @override
  FutureOr<void> build() {}

  /// IMPORTANT:
  /// Uploading a file via this method only stores it on the relay and returns the metadata.
  /// It DOES NOT broadcast the metadata (FileMetadata) as a NIP-94 event (kind 1063).
  ///
  /// The developer is responsible for sending the FileMetadata to the relay manually
  /// after a successful upload.
  Future<UploadResult> upload(
    MediaFile file, {
    FileAlt? alt,
    EventSigner? customEventSigner,
    bool skipDimCheck = false,
  }) async {
    if (!skipDimCheck && (file.width == null || file.height == null)) {
      throw UnknownFileResolutionException('File dimensions are missing');
    }

    final dimension = skipDimCheck ? null : '${file.width}x${file.height}';

    final url = await ref.read(fileStorageUrlProvider.future);

    final fileBytes = await File(file.path).readAsBytes();

    final authorizationToken = await generateAuthorizationToken(
      ref: ref,
      url: url,
      fileBytes: fileBytes,
      customEventSigner: customEventSigner,
      method: 'POST',
    );

    final response = await _makeUploadRequest(
      url: url,
      alt: alt,
      file: file,
      fileBytes: fileBytes,
      authorizationToken: authorizationToken,
    );

    final fileMetadata = FileMetadata.fromUploadResponseTags(
      response.nip94Event.tags,
      mimeType: file.mimeType,
    );

    final mediaAttachment = MediaAttachment(
      url: fileMetadata.url,
      mimeType: fileMetadata.mimeType,
      dimension: dimension,
      originalFileHash: fileMetadata.originalFileHash,
      alt: alt,
      thumb: fileMetadata.thumb,
      duration: file.duration,
    );

    return (fileMetadata: fileMetadata, mediaAttachment: mediaAttachment);
  }

  Future<UploadResponse> _makeUploadRequest({
    required String url,
    required MediaFile file,
    required Uint8List fileBytes,
    required String authorizationToken,
    FileAlt? alt,
  }) async {
    final fileName = file.name ?? file.basename;
    final multipartFile = MultipartFile.fromBytes(fileBytes, filename: fileName);

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      'caption': fileName,
      if (alt != null) 'alt': alt.toShortString(),
      'size': multipartFile.length,
      'content_type': file.mimeType,
    });

    try {
      final response = await ref.read(dioProvider).post<dynamic>(
            url,
            data: formData,
            options: Options(
              headers: {'Authorization': authorizationToken},
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
