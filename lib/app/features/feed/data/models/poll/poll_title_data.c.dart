// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll_title_data.c.freezed.dart';

@Freezed(copyWith: true)
class PollTitleData with _$PollTitleData {
  const factory PollTitleData({
    required String text,
  }) = _PollTitleData;

  factory PollTitleData.empty() => const PollTitleData(text: '');
}
