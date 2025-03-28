// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum DeletedEntityType {
  post,
  article;

  String getTitle(BuildContext context) => switch (this) {
        DeletedEntityType.post => context.i18n.feed_post_deleted,
        DeletedEntityType.article => context.i18n.feed_article_deleted,
      };
}

class DeletedEntity extends StatelessWidget {
  DeletedEntity({
    required this.entityType,
    super.key,
    double? bottomPadding,
    double? topPadding,
  })  : topPadding = topPadding ?? 10.0.s,
        bottomPadding = bottomPadding ?? 10.0.s;

  final DeletedEntityType entityType;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: topPadding, bottom: bottomPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.s),
          color: context.theme.appColors.tertararyBackground,
          border: Border.all(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
        ),
        child: Padding(
          padding:
              EdgeInsetsDirectional.only(top: 12.0.s, end: 16.0.s, bottom: 12.0.s, start: 12.0.s),
          child: Row(
            children: [
              Assets.svg.iconFeedDeletedpost
                  .icon(size: 20.0.s, color: context.theme.appColors.quaternaryText),
              SizedBox(width: 8.0.s),
              Text(
                entityType.getTitle(context),
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.quaternaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
