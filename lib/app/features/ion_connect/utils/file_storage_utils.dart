// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_storage_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_auth.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';

Future<String> generateAuthorizationToken({
  required Ref ref,
  required String url,
  required String method,
  List<int>? fileBytes,
  EventSigner? customEventSigner,
}) async {
  final ionConnectAuth = IonConnectAuth(url: url, method: method, payload: fileBytes);

  if (customEventSigner != null) {
    final authEvent = await ionConnectAuth.toEventMessage(customEventSigner);

    return ionConnectAuth.toAuthorizationHeader(authEvent);
  } else {
    final authEvent = await ref.read(ionConnectNotifierProvider.notifier).sign(ionConnectAuth);

    return ionConnectAuth.toAuthorizationHeader(authEvent);
  }
}

// TODO: handle delegatedToUrl when migrating to common relays
Future<String> getFileStorageApiUrl(
  Ref ref, {
  CancelToken? cancelToken,
}) async {
  final userRelays = await ref.read(currentUserRelaysProvider.future);
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

    final response = await ref.read(dioProvider).getUri<dynamic>(
          metadataUri,
          cancelToken: cancelToken,
        );
    final path = FileStorageMetadata.fromJson(
      json.decode(response.data as String) as Map<String, dynamic>,
    ).apiUrl;
    return metadataUri.replace(path: path).toString();
  } catch (error) {
    throw GetFileStorageUrlException(error);
  }
}
