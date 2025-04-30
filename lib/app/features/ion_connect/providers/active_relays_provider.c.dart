// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_relays_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ActiveRelays extends _$ActiveRelays {
  @override
  Set<String> build() {
    onLogout(ref, () {
      for (final url in state) {
        ref.invalidate(relayProvider(url));
      }
    });

    return {};
  }

  void addRelay(String url) {
    state = {...state, url};
  }

  void removeRelay(String url) {
    state = {...state}..remove(url);
  }
}
