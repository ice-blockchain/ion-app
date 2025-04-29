// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/relay_info.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_info_provider.c.g.dart';

/// https://github.com/nostr-protocol/nips/blob/master/11.md
@Riverpod(keepAlive: true)
Future<RelayInfo> relayInfo(Ref ref, String relayUrl) async {
  final repository = ref.watch(relayInfoRepositoryProvider);
  return repository.getRelayInfo(relayUrl);
}

@Riverpod(keepAlive: true)
RelayInfoRepository relayInfoRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return RelayInfoRepository(dio);
}

class RelayInfoRepository {
  RelayInfoRepository(this._dio);

  final Dio _dio;

  Future<RelayInfo> getRelayInfo(String relayUrl) async {
    try {
      final relayUri = Uri.parse(relayUrl);
      final infoUri = Uri(
        scheme: 'https',
        host: relayUri.host,
        port: relayUri.hasPort ? relayUri.port : null,
      );
      final response = await _dio.getUri<dynamic>(
        infoUri,
        options: Options(
          headers: {
            'Accept': 'application/nostr+json',
          },
        ),
      );
      return RelayInfo.fromJson(
        json.decode(response.data! as String) as Map<String, dynamic>,
      );
    } catch (error) {
      throw GetRelayInfoException(error, relayUrl: relayUrl);
    }
  }
}
