// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_notifier.c.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/article_preview.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_article_topics_item.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_article_visibility_item.dart';
import 'package:ion/app/features/feed/providers/article/create_article_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateArticlePreviewModal extends HookConsumerWidget {
  const CreateArticlePreviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddingValue = 20.0.s;

    final title = ref.watch(createArticleProvider).title;
    final selectedImage = ref.watch(createArticleProvider).image;
    final content = ref.watch(createArticleProvider).content;
    final imageIds = ref.watch(createArticleProvider).imageIds;
    final operations = ref.watch(createArticleProvider).operations;

    final isSubmitLoading = ref.watch(createArticleNotifierProvider).isLoading;

    ref.displayErrors(createArticleNotifierProvider);

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
          const SelectArticleVisibilityItem(),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScreenSideOffset.large(
                  child: Button(
                    disabled: isSubmitLoading,
                    leadingIcon: Assets.svg.iconFeedArticles.icon(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                    onPressed: () async {
                      await ref.read(createArticleNotifierProvider.notifier).create(
                            title: title,
                            content:
                                Document.fromDelta(Delta.fromOperations(operations)).toPlainText(),
                            imageId: selectedImage?.path,
                            mediaIds: imageIds,
                          );

                      if (!ref.read(createArticleNotifierProvider).hasError) {
                        if (ref.context.mounted) {
                          final state = GoRouterState.of(ref.context);
                          ref.context.go(state.currentTab.baseRouteLocation);
                        }
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
