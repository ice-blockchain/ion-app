// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/components/entities_list/components/article_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/generic_repost_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/post_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/repost_list_item.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';

class EntitiesList extends StatelessWidget {
  const EntitiesList({
    required this.entities,
    this.showParent = false,
    this.separator,
    super.key,
  });

  final List<NostrEntity> entities;
  final Widget? separator;
  final bool showParent;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: entities.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        final entity = entities[index];
        if (entity is PostEntity) {
          return PostListItem(post: entity, showParent: showParent);
        } else if (entity is ArticleEntity) {
          return ArticleListItem(article: entity);
        } else if (entity is RepostEntity) {
          return RepostListItem(repost: entity);
        } else if (entity is GenericRepostEntity) {
          return GenericRepostListItem(repost: entity);
        }
        return null;
      },
    );
  }
}
