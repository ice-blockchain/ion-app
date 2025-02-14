// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_relays_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ActiveRelays extends _$ActiveRelays {
  @override
  Set<String> build() {
    ref.listen(authProvider.select((state) => state.valueOrNull?.isAuthenticated), (prev, next) {
      if (prev != null && prev == true && next == false) {
        for (final url in state) {
          ref.invalidate(relayProvider(url));
        }
        ref.invalidateSelf();
      }
    });

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
