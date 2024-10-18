// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_edit_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class ConversationsEditMode extends _$ConversationsEditMode {
  @override
  bool build() {
    return false;
  }

  set editMode(bool editMode) {
    state = editMode;
  }
}
