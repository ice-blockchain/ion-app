// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/viewers/viewers.dart';

class StoryViewerContent extends StatelessWidget {
  const StoryViewerContent({required this.story, super.key});
  final Story story;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: story.maybeWhen(
        image: (data) => ImageStoryViewer(path: data.contentUrl),
        video: (data, muteState) => VideoStoryViewer(videoPath: data.contentUrl),
        orElse: () => const CenteredLoadingIndicator(),
      ),
    );
  }
}
