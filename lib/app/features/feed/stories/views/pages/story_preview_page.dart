// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/actions/story_share_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_image_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/media/story_video_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_preview/user/verified_account_list_item.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class StoryPreviewPage extends ConsumerWidget {
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
                    const VerifiedAccountListItem(),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 16.0.s),
                StoryShareButton(
                  onPressed: () {
                    final file = MediaFile(path: path, mimeType: mimeType);
                    ref
                        .read(
                      createPostNotifierProvider(CreatePostOption.story).notifier,
                    )
                        .create(content: '', mediaFiles: [file]);
                    FeedRoute().go(context);
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
