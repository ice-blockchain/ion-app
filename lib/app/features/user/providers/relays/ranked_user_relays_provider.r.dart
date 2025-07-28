// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/services/ion_connect/ion_connect_relays_ranker.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranked_user_relays_provider.r.g.dart';

/// Ranked relays are the relays that are sorted based on their latency.
///
/// Latency is measured by pinging the relays (check [ionConnectRelaysRankerProvider] for details).
/// Emits the ranked relays every time a relay ping is completed.
/// That is done to avoid hanging the app while waiting for unreachable relays to respond.
@Riverpod(keepAlive: true)
class RankedCurrentUserRelays extends _$RankedCurrentUserRelays {
  @override
  Stream<List<UserRelay>?> build() async* {
    final currentUserRelays = await ref.watch(currentUserIdentityConnectRelaysProvider.future);

    if (currentUserRelays == null) {
      yield null;
      return;
    }

    final cancelToken = CancelToken();

    yield* _rank(currentUserRelays, cancelToken: cancelToken);

    final pingIntervalSeconds =
        ref.watch(envProvider.notifier).get<int>(EnvVariable.RELAY_PING_INTERVAL_SECONDS);

    final controller = StreamController<List<UserRelay>?>();

    final timer = Timer.periodic(Duration(seconds: pingIntervalSeconds), (_) {
      controller.addStream(_rank(currentUserRelays, cancelToken: cancelToken));
    });

    ref.onDispose(() async {
      timer.cancel();
      cancelToken.cancel();
      await controller.close();
    });

    yield* controller.stream;
  }

  Stream<List<UserRelay>?> _rank(
    List<UserRelay> relays, {
    required CancelToken cancelToken,
  }) async* {
    if (relays.isEmpty) {
      yield null;
      return;
    }

    final relaysUrls = relays.map((relay) => relay.url).toList();

    Logger.log('[RELAY] Start ranking relays: $relaysUrls');

    final rankedResultsStream =
        ref.read(ionConnectRelaysRankerProvider).ranked(relaysUrls, cancelToken: cancelToken);

    var rankedRelays = <UserRelay>[];
    await for (final results in rankedResultsStream) {
      rankedRelays = results
          .map((url) => relays.firstWhereOrNull((relay) => relay.url == url))
          .nonNulls
          .toList();
      yield rankedRelays;
    }

    Logger.log('[RELAY] Ranked relays: $rankedRelays');
  }
}

@riverpod
Stream<List<String>> rankedRelayUrls(Ref ref, List<String>? relaysUrls) async* {
  if (relaysUrls == null || relaysUrls.isEmpty) {
    yield [];
    return;
  }
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  yield* ref.watch(ionConnectRelaysRankerProvider).ranked(relaysUrls, cancelToken: cancelToken);
}
