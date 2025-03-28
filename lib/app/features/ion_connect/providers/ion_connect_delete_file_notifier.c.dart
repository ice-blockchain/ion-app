// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_storage_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_auth.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_delete_file_notifier.c.freezed.dart';
part 'ion_connect_delete_file_notifier.c.g.dart';

@riverpod
class IonConnectDeleteFileNotifier extends _$IonConnectDeleteFileNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> delete(
    String fileHash, {
    EventSigner? customEventSigner,
  }) async {
    return deleteMultiple([fileHash], customEventSigner: customEventSigner);
  }

  Future<void> deleteMultiple(
    List<String> fileHashes, {
    EventSigner? customEventSigner,
  }) async {
    if (fileHashes.isEmpty) {
      return;
    }

    final storageUrl = await _getFileStorageApiUrl();

    await Future.wait(
      fileHashes.map(
        (fileHash) async {
          final url = '$storageUrl/$fileHash';
          final authorizationToken = await _generateAuthorizationToken(
            url: url,
            customEventSigner: customEventSigner,
          );

          await _makeDeleteRequest(
            url: url,
            fileHash: fileHash,
            authorizationToken: authorizationToken,
          );
        },
      ),
    );
  }

  Future<String> _generateAuthorizationToken({
    required String url,
    EventSigner? customEventSigner,
  }) async {
    final ionConnectAuth = IonConnectAuth(url: url, method: 'DELETE');

    if (customEventSigner != null) {
      final authEvent = await ionConnectAuth.toEventMessage(customEventSigner);

      return ionConnectAuth.toAuthorizationHeader(authEvent);
    } else {
      final authEvent = await ref.read(ionConnectNotifierProvider.notifier).sign(ionConnectAuth);

      return ionConnectAuth.toAuthorizationHeader(authEvent);
    }
  }

  // TODO: handle delegatedToUrl when migrating to common relays
  Future<String> _getFileStorageApiUrl() async {
    final userRelays = await ref.read(currentUserRelayProvider.future);
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
      final deletePath =
          FileStorageMetadata.fromJson(json.decode(response.data as String) as Map<String, dynamic>)
              .apiUrl;
      return metadataUri.replace(path: deletePath).toString();
    } catch (error) {
      throw GetFileStorageUrlException(error);
    }
  }

  Future<void> _makeDeleteRequest({
    required String url,
    required String fileHash,
    required String authorizationToken,
  }) async {
    try {
      final response = await ref.read(dioProvider).delete<dynamic>(
            url,
            options: Options(
              headers: {'Authorization': authorizationToken},
            ),
          );

      final deleteResponse = DeleteResponse.fromJson(
        json.decode(response.data as String) as Map<String, dynamic>,
      );

      if (deleteResponse.status != 'success') {
        throw Exception(deleteResponse.message);
      }
    } catch (error) {
      throw FileDeleteException(error, fileHash: fileHash);
    }
  }
}

@freezed
class DeleteResponse with _$DeleteResponse {
  const factory DeleteResponse({
    required String status,
    required String message,
  }) = _DeleteResponse;

  factory DeleteResponse.fromJson(Map<String, dynamic> json) => _$DeleteResponseFromJson(json);
}
