// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.c.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.c.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_notifier.c.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_arcticle_topics_item.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/select_arcticle_visibility_item.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateArticlePreviewModal extends HookConsumerWidget {
  const CreateArticlePreviewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paddingValue = 20.0.s;

    final article = ArticleEntity.fromEventMessage(mockedArticleEvents[0]);
    final eventReference = EventReference.fromNostrEntity(article);

    final isSubmitLoading = ref.watch(createArticleNotifierProvider).isLoading;

    ref.displayErrors(createArticleNotifierProvider);

    final isSubmitButtonEnabled = useMemoized(
      () => Validators.isArticleValid(
        article.data.title,
        article.data.image,
      ),
      [article.data.title, article.data.image],
    );

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
              nostrEntityProvider(eventReference: eventReference).overrideWith((_) => article),
            ],
            child: Article(eventReference: eventReference),
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
                    disabled: !isSubmitButtonEnabled && isSubmitLoading,
                    leadingIcon: Assets.svg.iconFeedArticles.icon(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                    onPressed: () async {
                      await ref.read(createArticleNotifierProvider.notifier).create(
                            title: 'Test article',
                            content: 'Test content',
                            imageId: 'some_image_id',
                          );

                      if (!ref.read(createArticleNotifierProvider).hasError) {
                        if (ref.context.mounted) {
                          ref.context.pop();
                        }

                        ref
                            .read(contentNotificationControllerProvider.notifier)
                            .showSuccess(ContentType.article);
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
