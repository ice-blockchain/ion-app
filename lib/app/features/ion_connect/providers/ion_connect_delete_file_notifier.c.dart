// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/delete_response.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/file_storage_url_provider.c.dart';
import 'package:ion/app/features/ion_connect/utils/file_storage_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

    final storageUrl = await ref.read(fileStorageUrlProvider.future);

    await Future.wait(
      fileHashes.map(
        (fileHash) async {
          final url = '$storageUrl/$fileHash';
          final authorizationToken = await generateAuthorizationToken(
            ref: ref,
            url: url,
            customEventSigner: customEventSigner,
            method: 'DELETE',
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
