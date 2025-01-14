// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_username_notifier.c.g.dart';

@Riverpod(keepAlive: true)
class CurrentUsernameNotifier extends _$CurrentUsernameNotifier {
  @override
  String? build() {
    return null;
  }

  void setUsername(String username) {
    state = username;
  }
}
