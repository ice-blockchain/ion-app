// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final storyViewingState = ref.watch(storyViewingControllerProvider);
    final currentPage = useState(0);

    useOnInit(() {
      ref.read(storyViewingControllerProvider.notifier).loadStories();
    });

    return Scaffold(
      backgroundColor: context.theme.appColors.primaryText,
      body: SafeArea(
        child: storyViewingState.maybeWhen(
          orElse: () => const CenteredLoadingIndicator(),
          data: (stories) {
            if (stories.isEmpty) {
              return const Center(child: Text('No stories available'));
            }

            final currentStory = stories[currentPage.value];

            return Column(
              children: [
                Expanded(
                  child: StoriesPageView(
                    stories: stories,
                    currentStory: currentStory.data,
                    currentPage: currentPage,
                    onPageChanged: (index) => currentPage.value = index,
                    onTapDown: (details) => _handleTapNavigation(
                      context,
                      details,
                      currentPage.value,
                      stories.length,
                      (nextPage) => currentPage.value = nextPage,
                    ),
                  ),
                ),
                SizedBox(height: 28.0.s),
                StoryProgressSegments(
                  stories: stories,
                  currentIndex: currentPage.value,
                  onStoryCompleted: () {
                    if (currentPage.value < stories.length - 1) {
                      currentPage.value++;
                    }
                  },
                ),
                ScreenBottomOffset(margin: 16.0.s),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleTapNavigation(
    BuildContext context,
    TapDownDetails details,
    int currentIndex,
    int totalStories,
    void Function(int) onPageChanged,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLeftSide = details.globalPosition.dx < screenWidth / 2;

    if (isLeftSide && currentIndex > 0) {
      onPageChanged(currentIndex - 1);
    } else if (!isLeftSide && currentIndex < totalStories - 1) {
      onPageChanged(currentIndex + 1);
    }
  }
}
