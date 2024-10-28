// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/stories_swiper.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_progress_bar.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingController = ref.read(storyViewingControllerProvider.notifier);
    final storyViewingState = ref.watch(storyViewingControllerProvider);

    useOnInit(storyViewingController.loadStories);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.theme.appColors.primaryText,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.theme.appColors.primaryText,
        body: SafeArea(
          child: storyViewingState.maybeMap(
            orElse: () => const CenteredLoadingIndicator(),
            ready: (ready) => Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: StoriesSwiper(
                        stories: ready.stories,
                        currentIndex: ready.currentIndex,
                        onPageChanged: storyViewingController.moveToStory,
                        onNext: () =>
                            ref.read(storyViewingControllerProvider.notifier).moveToNextStory(),
                        onPrevious: () =>
                            ref.read(storyViewingControllerProvider.notifier).moveToPreviousStory(),
                      ),
                    ),
                    SizedBox(height: 28.0.s),
                    StoryProgressBar(
                      onStoryCompleted: () => storyViewingState.whenOrNull(
                        ready: (stories, currentIndex) => currentIndex >= stories.length - 1
                            ? context.pop()
                            : storyViewingController.moveToNextStory(),
                      ),
                    ),
                    ScreenBottomOffset(margin: 16.0.s),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
