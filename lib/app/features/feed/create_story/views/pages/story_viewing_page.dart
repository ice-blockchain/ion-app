// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_header.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_input_field.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewing/components/story_progress_segments.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryViewingPage extends HookConsumerWidget {
  const StoryViewingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingState = ref.watch(storyViewingControllerProvider);
    final pageController = usePageController();
    final currentPage = useState(0);
    final messageController = useTextEditingController();

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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0.s),
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: stories.length,
                          onPageChanged: (index) => currentPage.value = index,
                          itemBuilder: (context, index) {
                            final story = stories[index];
                            return GestureDetector(
                              onTapDown: (details) => _handleTapDown(
                                details,
                                context,
                                pageController,
                                stories.length,
                              ),
                              child: StoryContent(story: story),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 14.0.s,
                        left: 16.0.s,
                        right: 22.0.s,
                        child: StoryHeader(currentStory: currentStory),
                      ),
                      Positioned(
                        bottom: 16.0.s,
                        left: 16.0.s,
                        right: 70.0.s,
                        child: StoryInputField(controller: messageController),
                      ),
                      Positioned(
                        bottom: 16.0.s,
                        right: 16.0.s,
                        child: StoryActionButtons(story: currentStory),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.0.s),
                StoryProgressSegments(
                  stories: stories,
                  currentIndex: currentPage.value,
                  onStoryCompleted: () {
                    if (currentPage.value < stories.length - 1) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
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

  void _handleTapDown(
    TapDownDetails details,
    BuildContext context,
    PageController pageController,
    int totalStories,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLeftSide = details.globalPosition.dx < screenWidth / 2;

    if (isLeftSide) {
      if (pageController.hasClients && pageController.page != null && pageController.page! > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (pageController.hasClients &&
          pageController.page != null &&
          pageController.page! < totalStories - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
