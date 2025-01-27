// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.c.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/article_preview.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_article_topics_item.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_article_who_can_reply_item.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateArticlePreviewModal extends HookConsumerWidget {
  const CreateArticlePreviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddingValue = 20.0.s;

    final DraftArticleState(:title, :image, :imageIds, :content, :imageColor) = ref.watch(draftArticleProvider);
    final whoCanReply = ref.watch(selectedWhoCanReplyOptionProvider);

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.article_preview_title),
          ),
          const HorizontalSeparator(),
          SizedBox(height: 12.0.s),
          const ArticlePreview(),
          SizedBox(height: 12.0.s),
          const HorizontalSeparator(),
          SizedBox(height: 40.0.s),
          const SelectArticleTopicsItem(),
          SizedBox(height: 20.0.s),
          const HorizontalSeparator(),
          SizedBox(height: 20.0.s),
          const SelectArticleWhoCanReplyItem(),
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
                    onPressed: () {
                      ref.read(createArticleProvider.notifier).create(
                            title: title,
                            content: content,
                            imageId: image?.path,
                            mediaIds: imageIds,
                            whoCanReply: whoCanReply,
                            imageColor: imageColor,
                          );

                      if (!ref.read(createArticleProvider).hasError && ref.context.mounted) {
                        final state = GoRouterState.of(ref.context);
                        ref.context.go(state.currentTab.baseRouteLocation);
                      }
                    },
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
