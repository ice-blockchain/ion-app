// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.r.dart';
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

  Future<List<String>> ranked(List<String> relaysUrls, {CancelToken? cancelToken}) async {
    final relaysMeasured =
        await Future.wait(relaysUrls.map((url) => _getRelayRank(url, cancelToken)));
    relaysMeasured.sort((a, b) => a.time.compareTo(b.time));
    return relaysMeasured.map((e) => e.url).toList();
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
