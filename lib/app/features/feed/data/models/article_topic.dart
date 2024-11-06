// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum ArticleTopic {
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
        ArticleTopic.blockchain => context.i18n.topic_blockchain,
        ArticleTopic.business => context.i18n.topic_business,
        ArticleTopic.cryptocurrency => context.i18n.topic_cryptocurrency,
        ArticleTopic.dataScience => context.i18n.topic_data_science,
        ArticleTopic.finance => context.i18n.topic_finance,
        ArticleTopic.games => context.i18n.topic_games,
        ArticleTopic.style => context.i18n.topic_style,
        ArticleTopic.lifechange => context.i18n.topic_lifechange,
        ArticleTopic.life => context.i18n.topic_life,
        ArticleTopic.trading => context.i18n.topic_trading,
        ArticleTopic.technology => context.i18n.topic_technology,
        ArticleTopic.travel => context.i18n.topic_travel,
        ArticleTopic.news => context.i18n.topic_news,
        ArticleTopic.people => context.i18n.topic_people,
        ArticleTopic.world => context.i18n.topic_world,
      };
}
