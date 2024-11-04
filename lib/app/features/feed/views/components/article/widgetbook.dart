// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article',
  type: Article,
)
Widget feedPostUseCase(BuildContext context) {
  final article = ArticleEntity.fromEventMessage(mockedArticleEvent);

  return Scaffold(
    body: Center(
      child: Article(
        article: article,
      ),
    ),
  );
}
