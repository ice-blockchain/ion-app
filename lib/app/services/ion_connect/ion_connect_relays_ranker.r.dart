// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_relays_ranker.r.g.dart';

@riverpod
IonConnectRelaysRanker ionConnectRelaysRanker(Ref ref) {
  return IonConnectRelaysRanker(
    dio: ref.watch(dioProvider),
  );
}

final class IonConnectRelaysRanker {
  const IonConnectRelaysRanker({
    required this.dio,
  });

  final Dio dio;

  /// Ranks the relays based on their latency.
  ///
  /// Returns a List of relay URLs sorted by their latency in ascending order (from best to worst).
  /// Emits results each time a relay is pinged.
  Stream<List<String>> ranked(List<String> relaysUrls, {CancelToken? cancelToken}) {
    final resultsController = StreamController<List<String>>();
    final measurements = <({int time, String url})>[];
    var completedCount = 0;
    for (final relayUrl in relaysUrls) {
      _getRelayRank(relayUrl, cancelToken).then(
        (result) {
          Logger.log('[RELAY] Relays ping results $result');
          measurements
            ..add(result)
            ..sort((a, b) => a.time.compareTo(b.time));
          resultsController.add(
            measurements.map((measurement) => measurement.url).toList(),
          );
        },
      ).catchError(
        (Object? reason) {
          Logger.error(
            reason is Object ? reason : 'Unknown error',
            message: '[RELAY] Error pinging relay $relayUrl',
          );
        },
      ).whenComplete(() {
        completedCount++;
        if (completedCount == relaysUrls.length) {
          resultsController.close();
        }
      });
    }

    return resultsController.stream;
  }

  Future<({String url, int time})> _getRelayRank(
    String relayUrl, [
    CancelToken? cancelToken,
  ]) async {
    try {
      final parsedRelayUrl = Uri.parse(relayUrl);
      final relayUri = Uri(
        scheme: 'https',
        host: parsedRelayUrl.host,
        port: parsedRelayUrl.hasPort ? parsedRelayUrl.port : null,
      );
      const timeout = Duration(seconds: 30);
      final stopWatch = Stopwatch()..start();
      await dio.headUri<void>(
        relayUri,
        options: Options(
          headers: {
            'Accept': 'application/nostr+json',
          },
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        cancelToken: cancelToken,
      );
      stopWatch.stop();
      return (url: relayUrl, time: stopWatch.elapsedMilliseconds);
    } catch (e) {
      // infinite rank if relay is unreachable
      return (url: relayUrl, time: 9999999999);
    }
  }
}
