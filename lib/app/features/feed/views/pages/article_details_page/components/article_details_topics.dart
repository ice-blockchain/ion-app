// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/topics_carousel/topics_carousel.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_section_header.dart';

class ArticleDetailsTopics extends StatelessWidget {
  const ArticleDetailsTopics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0.s),
        ScreenSideOffset.small(
          child: ArticleDetailsSectionHeader(
            title: context.i18n.topics_title,
            count: ArticleTopic.values.length,
          ),
        ),
        SizedBox(height: 16.0.s),
        TopicsCarousel(
          topics: ArticleTopic.values,
          padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
        ),
        SizedBox(height: 16.0.s),
      ],
    );
  }
}
