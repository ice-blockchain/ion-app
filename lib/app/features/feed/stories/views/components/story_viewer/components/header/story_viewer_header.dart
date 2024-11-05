// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';

class StoryViewerHeader extends StatelessWidget {
  const StoryViewerHeader({required this.currentStory, super.key});
  final Story currentStory;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14.0.s,
      left: 16.0.s,
      right: 22.0.s,
      child: Row(
        children: [
          Avatar(
            imageUrl: currentStory.data.imageUrl,
            size: 30.0.s,
          ),
          SizedBox(width: 8.0.s),
          Expanded(
            child: UserInfo(author: currentStory.data.author),
          ),
          HeaderActions(
            story: currentStory,
          ),
        ],
      ),
    );
  }
}
