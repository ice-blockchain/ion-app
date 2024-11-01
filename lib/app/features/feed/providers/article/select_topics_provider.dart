// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/topic_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_topics_provider.g.dart';

@riverpod
class SelectTopics extends _$SelectTopics {
  @override
  List<TopicType> build() {
    return [];
  }

  set selectTopics(List<TopicType> topics) {
    state = topics;
  }
}
