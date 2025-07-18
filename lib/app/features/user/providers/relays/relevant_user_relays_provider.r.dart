// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/ranked_user_relays_provider.r.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relevant_user_relays_provider.r.g.dart';

/// Relevant relays are the ones that might be used by a user.
///
/// They are fetched from identity based on the top relay URL from the ranked user relays.

@Riverpod(keepAlive: true)
Future<List<String>> relevantCurrentUserRelays(Ref ref) async {
  final rankedCurrentUserRelays = await ref.watch(rankedCurrentUserRelaysProvider.future);
  final topRelayUrl = rankedCurrentUserRelays?.data.list.firstOrNull?.url;
  if (topRelayUrl == null) {
    return [];
  }
  return ref.watch(relevantRelaysProvider(topRelayUrl).future);
}

@riverpod
Future<List<String>> relevantRelays(Ref ref, String relayUrl) async {
  final client = await ref.watch(ionIdentityClientProvider.future);
  final availableRelays = await client.users.availableIonConnectRelays(relayUrl: relayUrl);
  return availableRelays.map((relay) => relay.url).toList();
}

@Riverpod(keepAlive: true)
Future<List<String>> rankedRelevantCurrentUserRelaysUrls(Ref ref) async {
  final relevantRelaysUrls = await ref.watch(relevantCurrentUserRelaysProvider.future);

  final pingIntervalSeconds =
      ref.read(envProvider.notifier).get<int>(EnvVariable.RELAY_PING_INTERVAL_SECONDS);
  final timer = Timer.periodic(Duration(seconds: pingIntervalSeconds), (_) {
    ref.invalidate(rankedRelayUrlsProvider(relevantRelaysUrls));
  });
  ref.onDispose(timer.cancel);

  return ref.watch(rankedRelayUrlsProvider(relevantRelaysUrls).future);
}
