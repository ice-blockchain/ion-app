// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/stories_page_view.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_progress_segments.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryViewingPage extends HookConsumerWidget {
  const StoryViewingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingController = ref.read(storyViewingControllerProvider.notifier);
    final storyViewingState = ref.watch(storyViewingControllerProvider);

    useOnInit(storyViewingController.loadStories);

    return Scaffold(
      backgroundColor: context.theme.appColors.primaryText,
      body: SafeArea(
        child: storyViewingState.map(
          initial: (_) => const CenteredLoadingIndicator(),
          loading: (_) => const CenteredLoadingIndicator(),
          error: (error) => Center(child: Text(error.message)),
          ready: (ready) => Column(
            children: [
              Expanded(
                child: StoriesPageView(
                  stories: ready.stories,
                  currentIndex: ready.currentIndex,
                  onPageChanged: storyViewingController.moveToStory,
                  onTapDown: (details) => _handleTapNavigation(
                    context: context,
                    details: details,
                    currentIndex: ready.currentIndex,
                    totalStories: ready.stories.length,
                    onPrevious: storyViewingController.moveToPreviousStory,
                    onNext: storyViewingController.moveToNextStory,
                  ),
                ),
              ),
              SizedBox(height: 28.0.s),
              StoryProgressSegments(
                onStoryCompleted: storyViewingController.moveToNextStory,
              ),
              ScreenBottomOffset(margin: 16.0.s),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTapNavigation({
    required BuildContext context,
    required TapDownDetails details,
    required int currentIndex,
    required int totalStories,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLeftSide = details.globalPosition.dx < screenWidth / 2;

    if (isLeftSide && currentIndex > 0) {
      onPrevious();
    } else if (!isLeftSide && currentIndex < totalStories - 1) {
      onNext();
    }
  }
}
