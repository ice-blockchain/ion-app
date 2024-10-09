// SPDX-License-Identifier: ice License 1.0

import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.g.dart';

typedef RelaysState = Map<String, NostrRelay>;

@Riverpod(keepAlive: true)
Future<NostrRelay> relay(RelayRef ref, String url) async {
  //TODO: when to close?
  return NostrRelay.connect(url);
}
