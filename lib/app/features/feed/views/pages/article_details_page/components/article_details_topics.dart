// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/topics/topics_carousel.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_section_header.dart';

class ArticleDetailsTopics extends StatelessWidget {
  const ArticleDetailsTopics({required this.topics, super.key});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenSideOffset.small(
          child: ArticleDetailsSectionHeader(
            title: context.i18n.topics_title,
            count: topics.length,
          ),
        ),
        SizedBox(height: 16.0.s),
        TopicsCarousel(
          topics: topics,
          padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
        ),
      ],
    );
  }
}
