// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_write_relay.r.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserWriteRelay extends _$CurrentUserWriteRelay {
  @override
  String? build() {
    return null;
  }

  set relay(String? relayUrl) => state = relayUrl;
}
