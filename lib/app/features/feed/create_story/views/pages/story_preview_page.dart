// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/models.dart';
import 'package:ion/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_video/story_share_button.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_video/story_video_preview.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_video/verified_account_list_item.dart';
import 'package:ion/app/features/feed/views/pages/visibility_settings_modal/visibility_settings_modal.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class StoryPreviewPage extends ConsumerWidget {
  const StoryPreviewPage({
    required this.videoPath,
    super.key,
  });

  final String videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<StoryCameraState>(storyCameraControllerProvider, (_, next) {
      if (next is StoryCameraUploading && context.mounted) {
        FeedRoute().go(context);
      }
    });

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
                  children: [
                    Flexible(
                      child: StoryVideoPreview(videoPath: videoPath),
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
                  onPressed: () async {
                    final result = await showSimpleBottomSheet<bool>(
                      context: context,
                      child: const VisibilitySettingsModal(),
                    );

                    if (result ?? false) {
                      await ref.read(storyCameraControllerProvider.notifier).publishStory();
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
