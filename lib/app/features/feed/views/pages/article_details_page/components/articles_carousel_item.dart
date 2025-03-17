// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/image/app_cached_network_image.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ArticlesCarouselItem extends StatelessWidget {
  const ArticlesCarouselItem({required this.article, super.key});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    final topics = article.data.topics;

    if (article.isDeleted) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => ArticleDetailsRoute(eventReference: article.toEventReference().encode())
          .push<void>(context),
      child: Column(
        children: [
          UserInfo(
            pubkey: article.masterPubkey,
            trailing: UserInfoMenu(pubkey: article.masterPubkey),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (topics != null && topics.isNotEmpty) ...[
                        SizedBox(height: 10.0.s),
                        Text(
                          context.i18n.article_page_in_topic(topics.first.getTitle(context)),
                          style: context.theme.appTextThemes.caption2.copyWith(
                            color: context.theme.appColors.tertararyText,
                          ),
                          maxLines: 2,
                        ),
                      ],
                      SizedBox(height: 10.0.s),
                      Padding(
                        padding: EdgeInsets.only(right: 12.0.s),
                        child: Text(
                          article.data.title ?? '',
                          maxLines: 3,
                          style: context.theme.appTextThemes.subtitle3.copyWith(
                            color: context.theme.appColors.sharkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4.0.s),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0.s),
                    child: SizedBox(
                      width: 96.0.s,
                      height: 87.0.s,
                      child: article.data.image != null
                          ? AppCachedNetworkImage(
                              imageUrl: article.data.image!,
                              fit: BoxFit.cover,
                            )
                          : const ColoredBox(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
