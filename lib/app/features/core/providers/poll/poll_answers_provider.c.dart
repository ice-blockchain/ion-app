// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/poll/poll_answer.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poll_answers_provider.c.g.dart';

@riverpod
class PollAnswersNotifier extends _$PollAnswersNotifier {
  @override
  List<PollAnswer> build() {
    return [PollAnswer.empty()];
  }

  void addAnswer() {
    state = [...state, PollAnswer.empty()];
  }

  void updateAnswer(int index, String newText) {
    if (index >= 0 && index < state.length) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) state[i].copyWith(text: newText) else state[i],
      ];
    }
  }

  void removeAnswer(int index) {
    if (index >= 0 && index < state.length) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i != index) state[i],
      ];
    }
  }
}
