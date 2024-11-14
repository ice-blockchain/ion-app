// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article_data_provider.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleDetailsPage extends ConsumerWidget {
  const ArticleDetailsPage({
    required this.articleId,
    required this.pubkey,
    super.key,
  });

  final String articleId;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleEntity =
        ref.watch(articleDataProvider(articleId: articleId, pubkey: pubkey)).valueOrNull;

    if (articleEntity == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.article_page_title),
        actions: [
          IconButton(
            icon: Assets.svg.iconBookmarks.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Article(
                    articleId: articleEntity.id,
                    pubkey: articleEntity.pubkey,
                  ),
                ),
              ],
            ),
          ),
          const HorizontalSeparator(),
        ],
      ),
    );
  }
}
