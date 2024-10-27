// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_capture/story_control_button.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryViewerHeader extends StatelessWidget {
  const StoryViewerHeader({required this.currentStory, super.key});
  final Story currentStory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(currentStory.data.imageUrl),
          radius: 20.0.s,
        ),
        SizedBox(width: 10.0.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentStory.data.author,
                style: context.theme.appTextThemes.body.copyWith(color: Colors.white),
              ),
              Text(
                '@${currentStory.data.author}',
                style: context.theme.appTextThemes.caption.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        StoryControlButton(
          icon: Assets.svg.iconSheetClose.icon(color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
