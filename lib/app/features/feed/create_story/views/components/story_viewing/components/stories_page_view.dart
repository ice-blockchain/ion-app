// SPDX-License-Identifier: ice License 1.0

import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_header.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_input_field.dart';

class StoriesPageView extends HookConsumerWidget {
  const StoriesPageView({
    required this.stories,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final List<Story> stories;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: currentIndex);
    final previousIndex = useRef(currentIndex);
    final tapPosition = useState<Offset?>(null);
    final textController = useTextEditingController();

    useEffect(
      () {
        if (currentIndex != previousIndex.value) {
          previousIndex.value = currentIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted && pageController.hasClients) {
              pageController.animateToPage(
                currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        return null;
      },
      [currentIndex],
    );

    return CubePageView.builder(
      controller: pageController,
      itemCount: stories.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index, notifier) {
        final story = stories[index];
        return CubeWidget(
          index: index,
          pageNotifier: notifier,
          child: GestureDetector(
            onTapDown: (details) => tapPosition.value = details.globalPosition,
            onTap: () => _handleTap(
              context,
              tapPosition.value?.dx ?? 0,
            ),
            onLongPress: () {
              if (story is VideoStory) {
                ref.read(videoControllerProvider(story.data.contentUrl)).pause();
              }
            },
            onLongPressEnd: (_) {
              if (story is VideoStory) {
                ref.read(videoControllerProvider(story.data.contentUrl)).play();
              }
            },
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
                  child: StoryInputField(controller: textController),
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

  void _handleTap(BuildContext context, double tapX) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLeftSide = tapX < screenWidth / 2;

    if (isLeftSide) {
      onPrevious();
    } else {
      onNext();
    }
  }
}
