// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/viewers/viewers.dart';

class StoryViewerContent extends StatelessWidget {
  const StoryViewerContent({
    required this.post,
    super.key,
  });

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context) {
    final media = post.data.primaryMedia;

    if (media == null) {
      return const SizedBox.shrink();
    }

    return switch (media.mediaType) {
      MediaType.image => ImageStoryViewer(path: media.url),
      MediaType.video => VideoStoryViewer(videoPath: media.url),
      _ => const CenteredLoadingIndicator()
    };
  }
}
