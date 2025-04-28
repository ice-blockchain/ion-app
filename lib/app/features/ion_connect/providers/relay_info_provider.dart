// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/relay_info.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// https://github.com/nostr-protocol/nips/blob/master/11.md
final relayInfoProvider = FutureProvider.family<RelayInfo, String>((ref, relayUrl) async {
  final repository = ref.watch(relayInfoRepositoryProvider);
  return repository.getRelayInfo(relayUrl);
});

final relayInfoRepositoryProvider = Provider<RelayInfoRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RelayInfoRepository(dio);
});

class RelayInfoRepository {
  RelayInfoRepository(this._dio);

  final Dio _dio;

  Future<RelayInfo> getRelayInfo(String relayUrl) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        relayUrl,
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
