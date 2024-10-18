// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/poll/poll_title_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poll_title_notifier.g.dart';

@riverpod
class PollTitleNotifier extends _$PollTitleNotifier {
  @override
  PollTitleData build() {
    return PollTitleData.empty();
  }

  void onTextChanged(String newValue) {
    state = state.copyWith(text: newValue);
  }

  void clear() {
    state = PollTitleData.empty();
  }
}
