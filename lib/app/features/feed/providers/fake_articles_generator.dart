// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';

ArticleEntity generateFakeArticle() {
  final random = Random.secure();
  final randomEvent = mockedArticleEvents[random.nextInt(mockedArticleEvents.length)];

  final masterPubkeyTag = randomEvent.tags.firstWhere(
    (tag) => tag.isNotEmpty && tag[0] == 'b',
  );

  final masterPubkey = masterPubkeyTag.length > 1
      ? masterPubkeyTag[1]
      : '92c6aa30124f5edfe679a0e0676a9d86eaf2d9556d6eed73debf8a02d58a6b9e';

  final postEntity = ArticleEntity.fromEventMessage(randomEvent);

  return postEntity.copyWith(masterPubkey: masterPubkey);
}
