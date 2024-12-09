// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_topics_provider.c.g.dart';

@riverpod
class SelectTopics extends _$SelectTopics {
  @override
  List<ArticleTopic> build() {
    return [];
  }

  set selectTopics(List<ArticleTopic> topics) {
    state = topics;
  }
}
