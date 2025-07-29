// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_preview_result.f.freezed.dart';

@freezed
class StoryPreviewResult with _$StoryPreviewResult {
  const factory StoryPreviewResult.edited({
    required String originalPath,
    required String mimeType,
  }) = _Edited;

  const factory StoryPreviewResult.published() = _Published;

  const factory StoryPreviewResult.cancelled() = _Cancelled;
}
