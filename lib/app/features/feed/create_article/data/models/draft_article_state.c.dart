// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

part 'draft_article_state.c.freezed.dart';

@freezed
class DraftArticleState with _$DraftArticleState {
  const factory DraftArticleState({
    required Delta content,
    @Default([]) List<String> imageIds,
    MediaFile? image,
    @Default('') String title,
    String? imageColor,
    @Default({}) Map<String, String> codeBlocks,
    String? imageUrl,
  }) = _DraftArticleState;
}
