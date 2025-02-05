// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article',
  type: Article,
)
Widget feedPostUseCase(BuildContext context) {
  final articleEvent = EventMessage(
    id: 'f1e2d3c4b5a6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f',
    pubkey: '6e24af77db17d8f891e1967d2eb61877f18e4186980fa16958875a45b3f1350b',
    createdAt: DateTime.fromMillisecondsSinceEpoch(1730726700 * 1000),
    kind: 30023,
    tags: const [
      ['d', 'alpha-planet-exploration'],
      ['b', '92c6aa30124f5edfe679a0e0676a9d86eaf2d9556d6eed73debf8a02d58a6b9e'],
      ['a', '30023:6e24af77db17:alpha-planet-exploration'],
      ['r', 'localhost:5173'],
      ['published_at', '1730726700'],
      ['title', 'Discovering Alpha: Humanity’s First Interstellar Journey'],
      ['image', 'https://picsum.photos/800/600?random=101'],
      ['summary', 'Explore the Alpha Centauri mission that changed humanity forever.'],
      ['nsfw', 'false'],
      ['t', 'space'],
      ['t', 'exploration'],
    ],
    content:
        'In the year 2134, humanity embarked on its first interstellar journey to Alpha Centauri...',
    sig: 'sig-alpha',
  );
  final article = ArticleEntity.fromEventMessage(articleEvent);

  return Scaffold(
    body: Center(
      child: Article(
        eventReference: article.toEventReference(),
      ),
    ),
  );
}
