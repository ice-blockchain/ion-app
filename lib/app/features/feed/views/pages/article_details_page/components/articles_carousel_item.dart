// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';

class ArticlesCarouselItem extends StatelessWidget {
  const ArticlesCarouselItem({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final article = ArticleEntity.fromEventMessage(mockedArticleEvents[0]);

    return Column(
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
                    SizedBox(height: 10.0.s),
                    Text(
                      'in Bootcamp', //TODO: replace with topic
                      style: context.theme.appTextThemes.caption2.copyWith(
                        color: context.theme.appColors.tertararyText,
                      ),
                    ),
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
                        ? CachedNetworkImage(
                            imageUrl: article.data.image!,
                            fit: BoxFit.fitWidth,
                          )
                        : const ColoredBox(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
