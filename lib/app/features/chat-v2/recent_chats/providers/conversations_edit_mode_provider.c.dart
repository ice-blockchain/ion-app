// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_edit_mode_provider.c.g.dart';

@Riverpod()
class ConversationsEditMode extends _$ConversationsEditMode {
  @override
  bool build() {
    return false;
  }

  set editMode(bool editMode) {
    state = editMode;
  }
}
