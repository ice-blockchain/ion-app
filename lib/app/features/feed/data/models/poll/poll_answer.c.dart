// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll_answer.c.freezed.dart';

@Freezed(copyWith: true)
class PollAnswer with _$PollAnswer {
  const factory PollAnswer({
    required String text,
  }) = _PollAnswer;

  factory PollAnswer.empty() => const PollAnswer(text: '');
}
