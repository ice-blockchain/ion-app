// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum TopicType {
  blockchain,
  business,
  cryptocurrency,
  dataScience,
  finance,
  games,
  style,
  lifechange,
  life,
  trading,
  technology,
  travel,
  news,
  people,
  world;

  String getTitle(BuildContext context) => switch (this) {
        TopicType.blockchain => context.i18n.topic_blockchain,
        TopicType.business => context.i18n.topic_business,
        TopicType.cryptocurrency => context.i18n.topic_cryptocurrency,
        TopicType.dataScience => context.i18n.topic_data_science,
        TopicType.finance => context.i18n.topic_finance,
        TopicType.games => context.i18n.topic_games,
        TopicType.style => context.i18n.topic_style,
        TopicType.lifechange => context.i18n.topic_lifechange,
        TopicType.life => context.i18n.topic_life,
        TopicType.trading => context.i18n.topic_trading,
        TopicType.technology => context.i18n.topic_technology,
        TopicType.travel => context.i18n.topic_travel,
        TopicType.news => context.i18n.topic_news,
        TopicType.people => context.i18n.topic_people,
        TopicType.world => context.i18n.topic_world,
      };
}
