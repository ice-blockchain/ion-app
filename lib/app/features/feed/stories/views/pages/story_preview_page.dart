// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/actions/story_share_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_image_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_video_preview.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/who_can_reply_settings_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryPreviewPage extends HookConsumerWidget {
  const StoryPreviewPage({
    required this.path,
    required this.mimeType,
    super.key,
  });

  final String path;
  final String? mimeType;

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
                        MediaType.image => StoryImagePreview(path: path),
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
                      ),
                      constraints: BoxConstraints(minHeight: 40.0.s),
                      onTap: () => showSimpleBottomSheet<void>(
                        context: context,
                        child: WhoCanReplySettingsModal(
                          title: context.i18n.who_can_reply_settings_title_story,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 16.0.s),
                StoryShareButton(
                  isLoading: isPublishing.value,
                  onPressed: isPublishing.value
                      ? null
                      : () async {
                          isPublishing.value = true;

                          final createPostNotifier = ref.read(
                            createPostNotifierProvider(CreatePostOption.story).notifier,
                          );

                          if (mediaType == MediaType.video) {
                            await createPostNotifier.create(
                              mediaFiles: [MediaFile(path: path, mimeType: mimeType)],
                              whoCanReply: whoCanReply,
                            );
                          } else if (mediaType == MediaType.image) {
                            await createPostNotifier.create(
                              mediaFiles: [
                                MediaFile(
                                  path: path,
                                  mimeType: mimeType,
                                ),
                              ],
                              whoCanReply: whoCanReply,
                            );
                          }

                          if (context.mounted) {
                            isPublishing.value = false;
                          }
                        },
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
