// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_relays_ranker.c.g.dart';

@riverpod
IonConnectRelaysRanker ionConnectRelaysRanker(Ref ref, List<String> relaysUrls) {
  return IonConnectRelaysRanker(
    dio: ref.watch(dioProvider),
    relaysUrls: relaysUrls,
  );
}

final class IonConnectRelaysRanker {
  const IonConnectRelaysRanker({
    required this.dio,
    required this.relaysUrls,
  });

  final Dio dio;
  final List<String> relaysUrls;

  Future<List<String>> ranked() async {
    final relaysMeasured = await Future.wait(relaysUrls.map(_getRelayRank));
    relaysMeasured.sort((a, b) => a.time.compareTo(b.time));
    return relaysMeasured.map((e) => e.url).toList();
  }

  Future<({String url, int time})> _getRelayRank(String relayUrl) async {
    try {
      final parsedRelayUrl = Uri.parse(relayUrl);
      final relayUri = Uri(
        scheme: 'https',
        host: parsedRelayUrl.host,
        port: parsedRelayUrl.hasPort ? parsedRelayUrl.port : null,
      );
      final stopWatch = Stopwatch()..start();
      await dio.headUri<void>(
        relayUri,
        options: Options(
          headers: {
            'Accept': 'application/nostr+json',
          },
        ),
      );
      stopWatch.stop();
      return (url: relayUrl, time: stopWatch.elapsedMilliseconds);
    } catch (e) {
      // infinite rank if relay is unreachable
      return (url: relayUrl, time: 9999999999);
    }
  }
}
