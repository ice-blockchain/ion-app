// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CreateArticle extends _$CreateArticle {
  @override
  CreateArticleState build() {
    return CreateArticleState();
  }

  void updateArticleDetails(QuillController textEditorController, MediaFile? image, String title) {
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

class CreateArticleState {
  CreateArticleState({
    this.content = '',
    this.image,
    this.title = '',
    this.imageIds = const [],
  });

  final String content;
  final List<String> imageIds;
  final MediaFile? image;
  final String? title;

  CreateArticleState copyWith({
    String content = '',
    String title = '',
    List<String> imageIds = const [],
    MediaFile? image,
  }) {
    return CreateArticleState(
      content: content,
      imageIds: imageIds,
      title: title,
      image: image ?? this.image,
    );
  }
}
