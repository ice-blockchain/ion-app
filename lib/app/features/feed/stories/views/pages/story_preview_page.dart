// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.m.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.f.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/current_user_story_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/actions/story_share_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/actions/story_topics_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/post_screenshot_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_image_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_video_preview.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/who_can_reply_settings_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/compressors/image_compressor.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryPreviewPage extends HookConsumerWidget {
  const StoryPreviewPage({
    required this.path,
    required this.mimeType,
    this.eventReference,
    this.isPostScreenshot = false,
    super.key,
  });

  final String path;
  final String? mimeType;
  final EventReference? eventReference;
  final bool isPostScreenshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaType = mimeType != null ? MediaType.fromMimeType(mimeType!) : MediaType.unknown;
    final whoCanReply = ref.watch(selectedWhoCanReplyOptionProvider);
    final isPublishing = useState(false);

    ref
      ..displayErrors(createPostNotifierProvider(CreatePostOption.story))
      ..listenSuccess(
        createPostNotifierProvider(CreatePostOption.story),
        (_) {
          if (context.mounted) {
            FeedRoute().go(context);
          }
        },
      );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar.modal(
              title: Text(
                context.i18n.story_preview_title,
                style: context.theme.appTextThemes.subtitle2,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.s),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: switch (mediaType) {
                        MediaType.video => StoryVideoPreview(path: path),
                        MediaType.image => isPostScreenshot
                            ? PostScreenshotPreview(path: path)
                            : StoryImagePreview(path: path),
                        MediaType.audio => const CenteredLoadingIndicator(),
                        MediaType.unknown => const CenteredLoadingIndicator(),
                      },
                    ),
                    SizedBox(height: 8.0.s),
                    ListItem(
                      title: Text(
                        whoCanReply.getTitle(context),
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: context.theme.appColors.secondaryBackground,
                      leading: whoCanReply.getIcon(context),
                      trailing: Assets.svg.iconArrowRight.icon(
                        color: context.theme.appColors.primaryAccent,
                        size: 16.s,
                      ),
                      constraints: BoxConstraints(minHeight: 40.0.s),
                      onTap: () => showSimpleBottomSheet<void>(
                        context: context,
                        child: WhoCanReplySettingsModal(
                          title: context.i18n.who_can_reply_settings_title_story,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.s),
                      child: const HorizontalSeparator(),
                    ),
                    const StoryTopicsButton(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.s),
                      child: const HorizontalSeparator(),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 10.0.s),
                StoryShareButton(
                  isLoading: isPublishing.value,
                  onPressed: isPublishing.value
                      ? null
                      : () async {
                          isPublishing.value = true;

                          final createPostNotifier = ref.read(
                            createPostNotifierProvider(CreatePostOption.story).notifier,
                          );

                          if (eventReference != null || mediaType == MediaType.image) {
                            final dimensions = await ref
                                .read(imageCompressorProvider)
                                .getImageDimension(path: path);

                            await createPostNotifier.create(
                              mediaFiles: [
                                MediaFile(
                                  path: path,
                                  mimeType: mimeType,
                                  width: dimensions.width,
                                  height: dimensions.height,
                                ),
                              ],
                              whoCanReply: whoCanReply,
                              quotedEvent: eventReference,
                              topics: ref.read(selectedInterestsNotifierProvider),
                            );
                          } else if (mediaType == MediaType.video) {
                            await createPostNotifier.create(
                              mediaFiles: [MediaFile(path: path, mimeType: mimeType)],
                              whoCanReply: whoCanReply,
                              topics: ref.read(selectedInterestsNotifierProvider),
                            );
                          }

                          final pubkey = ref.read(currentPubkeySelectorProvider) ?? '';
                          ref.read(currentUserStoryProvider.notifier).refresh();
                          ref.read(userStoriesProvider(pubkey).notifier).refresh();

                          if (context.mounted) {
                            isPublishing.value = false;
                          }
                        },
                ),
                ScreenBottomOffset(margin: 16.0.s),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
