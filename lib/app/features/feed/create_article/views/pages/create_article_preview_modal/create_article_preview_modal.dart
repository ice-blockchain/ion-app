// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_arcticle_topics_item.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_arcticle_visibility_item.dart';
import 'package:ion/app/features/feed/data/models/article_data.dart';
import 'package:ion/app/features/feed/providers/article_data_provider.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateArticlePreviewModal extends StatelessWidget {
  const CreateArticlePreviewModal({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingValue = 20.0.s;

    final article = ArticleEntity.fromEventMessage(mockedArticleEvent);

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.article_preview_title),
          ),
          const HorizontalSeparator(),
          ProviderScope(
            overrides: [
              articleDataProvider(articleId: article.id, pubkey: article.pubkey)
                  .overrideWith((_) => article),
            ],
            child: Article(articleId: article.id, pubkey: article.pubkey),
          ),
          SizedBox(height: 12.0.s),
          const HorizontalSeparator(),
          SizedBox(height: 40.0.s),
          const SelectArticleTopicsItem(),
          SizedBox(height: 20.0.s),
          const HorizontalSeparator(),
          SizedBox(height: 20.0.s),
          const SelectArticleVisibilityItem(),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScreenSideOffset.large(
                  child: Button(
                    leadingIcon: Assets.svg.iconFeedArticles.icon(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                    onPressed: () {},
                    label: Text(context.i18n.button_publish),
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
                SizedBox(height: paddingValue + MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
