// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_image_viewer.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_video_viewer.dart';

class StoryContent extends StatelessWidget {
  const StoryContent({required this.story, super.key});
  final Story story;

  @override
  Widget build(BuildContext context) {
    return story.maybeWhen(
      image: (data) => StoryImageViewer(path: data.contentUrl),
      video: (data, muteState) => StoryVideoViewer(videoPath: data.contentUrl),
      orElse: () => const CenteredLoadingIndicator(),
    );
  }
}
