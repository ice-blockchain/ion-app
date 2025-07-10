// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/relays/ranked_user_relays_provider.r.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relevant_current_user_relays_provider.r.g.dart';

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
  return client.users.availableIonConnectRelays(
    relayUrl: relayUrl,
  );
}
