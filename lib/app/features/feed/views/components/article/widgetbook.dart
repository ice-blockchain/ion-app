// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article',
  type: Article,
)
Widget feedPostUseCase(BuildContext context) {
  final article = ArticleEntity.fromEventMessage(mockedArticleEvents[0]);
  final eventReference = EventReference.fromIonConnectEntity(article);

  return Scaffold(
    body: Center(
      child: Article(
        eventReference: eventReference,
      ),
    ),
  );
}
