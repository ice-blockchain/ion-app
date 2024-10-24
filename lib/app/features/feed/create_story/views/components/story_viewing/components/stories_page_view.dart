// SPDX-License-Identifier: ice License 1.0

import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_header.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_input_field.dart';

class StoriesPageView extends StatelessWidget {
  const StoriesPageView({
    required this.stories,
    required this.currentStory,
    required this.currentPage,
    required this.onPageChanged,
    required this.onTapDown,
    super.key,
  });

  final List<Story> stories;
  final StoryData currentStory;
  final ValueNotifier<int> currentPage;
  final void Function(int) onPageChanged;
  final void Function(TapDownDetails) onTapDown;

  @override
  Widget build(BuildContext context) {
    return CubePageView.builder(
      itemCount: stories.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index, notifier) {
        final story = stories[index];
        return CubeWidget(
          index: index,
          pageNotifier: notifier,
          child: GestureDetector(
            onTapDown: onTapDown,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0.s),
                  child: StoryContent(story: story),
                ),
                Positioned(
                  top: 14.0.s,
                  left: 16.0.s,
                  right: 22.0.s,
                  child: StoryHeader(currentStory: story),
                ),
                Positioned(
                  bottom: 16.0.s,
                  left: 16.0.s,
                  right: 70.0.s,
                  child: StoryInputField(controller: TextEditingController()),
                ),
                Positioned(
                  bottom: 16.0.s,
                  right: 16.0.s,
                  child: StoryActionButtons(story: story),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
