// SPDX-License-Identifier: ice License 1.0

import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.g.dart';

typedef RelaysState = Map<String, NostrRelay>;

@Riverpod(keepAlive: true)
Future<NostrRelay> relay(RelayRef ref, String url) async {
  // TODO: think how to implement the following
  //
  // Close a connection if ALL of the following happens:
  // 1. Has no active subscriptions
  // 2. it has been at least 30s since last message from the relay was received
  return NostrRelay.connect(url);
}
