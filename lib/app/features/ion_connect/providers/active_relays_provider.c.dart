// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_relays_provider.c.g.dart';

@riverpod
class ActiveRelays extends _$ActiveRelays {
  @override
  Set<String> build() {
    return {};
  }

  void addRelay(String relayUrl) {
    state = {...state, relayUrl};
  }

  void removeRelay(String relayUrl) {
    final newState = Set<String>.from(state)..remove(relayUrl);
    state = newState;
  }
}
