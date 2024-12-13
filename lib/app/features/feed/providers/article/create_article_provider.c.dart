// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CreateArticle extends _$CreateArticle {
  @override
  CreateArticleState build() {
    return CreateArticleState(
      image: null,
      title: '',
      content: '',
    );
  }

  void updateImage(MediaFile? image) {
    state = state.copyWith(image: image);
  }

  void updateTitle(String? title) {
    state = state.copyWith(title: title);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }
}

class CreateArticleState {
  CreateArticleState({
    required this.image,
    required this.title,
    required this.content,
  });
  final MediaFile? image;
  final String? title;
  final String? content;

  CreateArticleState copyWith({
    MediaFile? image,
    String? title,
    String? content,
  }) {
    return CreateArticleState(
      image: image ?? this.image,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
