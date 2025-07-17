// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/views/pages/share_via_message_modal/components/share_copy_link_option.dart';
import 'package:ion/app/features/chat/views/pages/share_via_message_modal/components/share_options_menu_item.dart';
import 'package:ion/app/features/chat/views/pages/share_via_message_modal/components/share_post_to_story_content.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.r.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/services/share/social_share_service.r.dart';
import 'package:ion/app/utils/screenshot_utils.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareOptions extends HookConsumerWidget {
  const ShareOptions({required this.eventReference, super.key});

  final EventReference eventReference;

  static double get iconSize => 28.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCapturing = useState(false);

    final entity = ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    if (entity == null) {
      return const SizedBox.shrink();
    }

    final isPost = entity is ModifiablePostEntity && entity.data.expiration == null;

    final shareUrl = eventReference.encode();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 20.0.s, end: 16.0.s, start: 16.0.s),
        child: SeparatedRow(
          separator: SizedBox(width: 12.0.s),
          children: [
            if (isPost)
              ShareOptionsMenuItem(
                buttonType: ButtonType.primary,
                icon: isCapturing.value
                    ? const CenteredLoadingIndicator()
                    : Assets.svg.iconFeedStory.icon(size: iconSize),
                label: context.i18n.feed_add_story,
                onPressed: isCapturing.value ? () {} : () => _onSharePostToStory(ref, isCapturing),
              ),
            ShareCopyLinkOption(shareUrl: shareUrl, iconSize: iconSize),
            if (isPost)
              ShareOptionsMenuItem(
                buttonType: ButtonType.dropdown,
                icon: Assets.svg.iconBookmarks.icon(size: iconSize, color: Colors.black),
                label: context.i18n.button_bookmark,
                onPressed: () async {
                  await ref
                      .read(
                        feedBookmarksNotifierProvider(
                          collectionDTag: BookmarksSetType.homeFeedCollectionsAll.dTagName,
                        ).notifier,
                      )
                      .toggleBookmark(eventReference);
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
            ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedWhatsapp.icon(size: iconSize),
              label: context.i18n.feed_whatsapp,
              onPressed: () {
                ref.read(socialShareServiceProvider).shareToWhatsApp(shareUrl);
              },
            ),
            ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedTelegram.icon(size: iconSize),
              label: context.i18n.feed_telegram,
              onPressed: () {
                ref.read(socialShareServiceProvider).shareToTelegram(shareUrl);
              },
            ),
            ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconLoginXlogo.icon(size: iconSize),
              label: context.i18n.feed_x,
              onPressed: () {
                ref.read(socialShareServiceProvider).shareToTwitter(shareUrl);
              },
            ),
            ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedMore.icon(size: iconSize),
              label: context.i18n.feed_more,
              onPressed: () {
                ref.read(socialShareServiceProvider).shareToMore(shareUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSharePostToStory(WidgetRef ref, ValueNotifier<bool> isCapturing) async {
    final context = ref.context;
    isCapturing.value = true;

    try {
      final postItselfEntity =
          ref.read(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;
      if (postItselfEntity == null || postItselfEntity is! ModifiablePostEntity) {
        isCapturing.value = false;
        return;
      }

      final postEntityAsyncValue = ref.read(
        ionConnectEntityWithCountersProvider(eventReference: eventReference),
      );

      // ignore: scoped_providers_should_specify_dependencies
      final postWidget = ProviderScope(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          currentIdentityKeyNameSelectorProvider.overrideWithValue(
            ref.read(currentIdentityKeyNameSelectorProvider),
          ),
          // ignore: scoped_providers_should_specify_dependencies
          ionConnectEntityWithCountersProvider(
            eventReference: eventReference,
          ).overrideWithValue(postEntityAsyncValue),
          // ignore: scoped_providers_should_specify_dependencies
          userMetadataProvider(eventReference.masterPubkey),
        ],
        child: SharePostToStoryContent(
          eventReference: eventReference,
          postItselfEntity: postItselfEntity,
        ),
      );

      final tempFile = await captureWidgetScreenshot(
        context: context,
        widget: postWidget,
      );

      if (tempFile != null && context.mounted) {
        context.pop();
        await StoryPreviewRoute(
          path: tempFile.path,
          mimeType: 'image/png',
          eventReference: eventReference.encode(),
          isPostScreenshot: true,
        ).push<void>(context);
      }
    } finally {
      if (context.mounted) {
        isCapturing.value = false;
      }
    }
  }
}
