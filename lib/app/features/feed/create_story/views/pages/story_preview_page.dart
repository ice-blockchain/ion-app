// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_video/share_story_button.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_video/story_video_preview.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_video/verified_account_list_item.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/visibility_settings_modal.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';

class StoryPreviewPage extends ConsumerWidget {
  const StoryPreviewPage({
    required this.videoPath,
    super.key,
  });

  final String videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ShareStoryButton(
                  onPressed: () {
                    showSimpleBottomSheet<void>(
                      context: context,
                      child: const VisibilitySettingsModal(),
                    );
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
