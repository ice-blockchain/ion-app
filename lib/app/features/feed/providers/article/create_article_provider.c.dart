// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.freezed.dart';
part 'create_article_provider.c.g.dart';

@freezed
class CreateArticleState with _$CreateArticleState {
  const factory CreateArticleState({
    @Default('') String content,
    @Default([]) List<String> imageIds,
    MediaFile? image,
    @Default('') String title,
  }) = _CreateArticleState;
}

@Riverpod(keepAlive: true)
class CreateArticle extends _$CreateArticle {
  @override
  CreateArticleState build() {
    return const CreateArticleState();
  }

  void updateArticleDetails(
    QuillController textEditorController,
    MediaFile? image,
    String title,
  ) {
    final deltaJson = jsonEncode(textEditorController.document.toDelta().toJson());
    final imageIds = ArticleData.extractImageIds(textEditorController);

    state = state.copyWith(
      content: deltaJson,
      imageIds: imageIds,
      image: image,
      title: title.trim(),
    );
  }
}
