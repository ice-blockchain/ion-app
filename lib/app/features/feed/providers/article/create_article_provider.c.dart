// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
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
      operations: [],
      imageIds: [],
    );
  }

  void updateImage(MediaFile? image) {
    state = state.copyWith(image: image);
  }

  void updateTitle(String? title) {
    state = state.copyWith(title: title?.trim());
  }

  void updateContent(QuillController textEditorController) {
    final deltaJson = jsonEncode(textEditorController.document.toDelta().toJson());
    state = state.copyWith(content: deltaJson);
  }

  void updateOperationsAndImageIds(QuillController textEditorController) {
    final operations = <Operation>[];
    final imageIds = <String>[];

    for (final operation in textEditorController.document.toDelta().operations) {
      final data = operation.data;
      if (data is Map<String, dynamic> && data.containsKey(textEditorSingleImageKey)) {
        imageIds.add(data[textEditorSingleImageKey] as String);
      } else {
        operations.add(operation);
      }
    }

    state = state.copyWith(
      operations: operations,
      imageIds: imageIds,
    );
  }
}

class CreateArticleState {
  CreateArticleState({
    required this.image,
    required this.title,
    required this.content,
    required this.operations,
    required this.imageIds,
  });

  final MediaFile? image;
  final String? title;
  final String content; // JSON string representation of content
  final List<Operation> operations;
  final List<String> imageIds;

  CreateArticleState copyWith({
    MediaFile? image,
    String? title,
    String? content,
    List<Operation>? operations,
    List<String>? imageIds,
  }) {
    return CreateArticleState(
      image: image ?? this.image,
      title: title ?? this.title,
      content: content ?? this.content,
      operations: operations ?? this.operations,
      imageIds: imageIds ?? this.imageIds,
    );
  }
}
