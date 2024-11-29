// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_provider.g.dart';

/// Mocked implementation of the groups provider.
/// Should be replaced with real logic or removed when this functionality
/// will be implemented.
@Riverpod(keepAlive: true)
class Groups extends _$Groups {
  @override
  Map<String, Group> build() {
    final result = <String, Group>{};
    return Map<String, Group>.unmodifiable(result);
  }

  void setChannel(String id, Group data) {
    final newState = Map<String, Group>.from(state);
    newState[id] = data;
    state = Map<String, Group>.unmodifiable(newState);
  }
}
