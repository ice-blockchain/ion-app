// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_share_provider.g.dart';

@riverpod
class StoryShareController extends _$StoryShareController {
  @override
  Set<String> build() => {};

  void toggleContact(String contactId) {
    if (state.contains(contactId)) {
      state = state.difference({contactId});
    } else {
      state = {...state, contactId};
    }
  }

  void clearSelection() {
    state = {};
  }
}
