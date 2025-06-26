// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.r.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.m.dart';
import 'package:ion/app/features/feed/create_article/views/pages/article_preview_modal/components/article_preview.dart';
import 'package:ion/app/features/feed/create_article/views/pages/article_preview_modal/components/select_article_topics_item.dart';
import 'package:ion/app/features/feed/create_article/views/pages/article_preview_modal/components/select_article_who_can_reply_item.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticlePreviewModal extends HookConsumerWidget {
  factory ArticlePreviewModal({
    Key? key,
  }) = ArticlePreviewModal.create;

  const ArticlePreviewModal._({super.key, this.modifiedEvent});

  factory ArticlePreviewModal.create({
    Key? key,
  }) {
    return ArticlePreviewModal._(
      key: key,
    );
  }

  factory ArticlePreviewModal.edit({
    required EventReference modifiedEvent,
    Key? key,
  }) {
    return ArticlePreviewModal._(
      key: key,
      modifiedEvent: modifiedEvent,
    );
  }

  final EventReference? modifiedEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DraftArticleState(
      :title,
      :image,
      :imageIds,
      :content,
      :imageColor,
      :imageUrl,
    ) = ref.watch(draftArticleProvider);
    final whoCanReply = ref.watch(selectedWhoCanReplyOptionProvider);
    final selectedTopics = ref.watch(selectedInterestsNotifierProvider);

    useOnInit(
      () {
        if (modifiedEvent == null) return;
        final modifiableEntity =
            ref.read(ionConnectEntityProvider(eventReference: modifiedEvent!)).valueOrNull;
        if (modifiableEntity is! ArticleEntity) return;

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(selectedInterestsNotifierProvider.notifier).selectInterests =
              modifiableEntity.data.topics.toSet(),
        );
      },
      [modifiedEvent],
    );

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.article_preview_title),
          ),
          const HorizontalSeparator(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  SizedBox(height: 40.0.s),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HorizontalSeparator(),
              SizedBox(height: 16.0.s),
              ScreenSideOffset.large(
                child: Button(
                  leadingIcon: Assets.svg.iconFeedArticles.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                  onPressed: () {
                    final type = modifiedEvent != null
                        ? CreateArticleOption.modify
                        : CreateArticleOption.plain;

                    if (modifiedEvent != null) {
                      ref.read(createArticleProvider(type).notifier).modify(
                            title: title,
                            content: content,
                            topics: selectedTopics,
                            coverImagePath: image?.path,
                            whoCanReply: whoCanReply,
                            imageColor: imageColor,
                            originalImageUrl: imageUrl,
                            eventReference: modifiedEvent!,
                          );
                    } else {
                      ref.read(createArticleProvider(type).notifier).create(
                            title: title,
                            content: content,
                            topics: selectedTopics,
                            coverImagePath: image?.path,
                            mediaIds: imageIds,
                            whoCanReply: whoCanReply,
                            imageColor: imageColor,
                          );
                    }

                    if (!ref.read(createArticleProvider(type)).hasError && ref.context.mounted) {
                      final state = GoRouterState.of(ref.context);
                      ref.context.go(state.currentTab.baseRouteLocation);
                    }
                  },
                  label: Text(context.i18n.button_publish),
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
              ScreenBottomOffset(margin: 36.0.s),
            ],
          ),
        ],
      ),
    );
  }
}
