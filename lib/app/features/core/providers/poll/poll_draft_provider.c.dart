// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/poll/poll_answer.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poll_draft_provider.c.g.dart';

class PollDraft {
  const PollDraft({
    required this.answers,
    required this.lengthDays,
    required this.lengthHours,
    required this.added,
  });

  factory PollDraft.initial() => PollDraft(
        answers: [PollAnswer.empty()],
        lengthDays: 1,
        lengthHours: 0,
        added: false,
      );
  final List<PollAnswer> answers;
  final int lengthDays;
  final int lengthHours;
  final bool added;

  PollDraft copyWith({
    List<PollAnswer>? answers,
    int? lengthDays,
    int? lengthHours,
    bool? added,
  }) {
    return PollDraft(
      answers: answers ?? this.answers,
      lengthDays: lengthDays ?? this.lengthDays,
      lengthHours: lengthHours ?? this.lengthHours,
      added: added ?? this.added,
    );
  }
}

@riverpod
class PollDraftNotifier extends _$PollDraftNotifier {
  @override
  PollDraft build() => PollDraft.initial();

  void addAnswer() {
    state = state.copyWith(answers: [...state.answers, PollAnswer.empty()]);
  }

  void updateAnswer(int index, String newText) {
    if (index >= 0 && index < state.answers.length) {
      state = state.copyWith(
        answers: [
          for (int i = 0; i < state.answers.length; i++)
            if (i == index) state.answers[i].copyWith(text: newText) else state.answers[i],
        ],
      );
    }
  }

  void removeAnswer(int index) {
    if (index >= 0 && index < state.answers.length) {
      state = state.copyWith(
        answers: [
          for (int i = 0; i < state.answers.length; i++)
            if (i != index) state.answers[i],
        ],
      );
    }
  }

  void setLengthDays(int days) {
    state = state.copyWith(lengthDays: days);
  }

  void setLengthHours(int hours) {
    state = state.copyWith(lengthHours: hours);
  }

  void markPollAdded() {
    state = state.copyWith(added: true);
  }

  void reset() {
    state = PollDraft.initial();
  }
}
