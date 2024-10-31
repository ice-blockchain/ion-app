// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/extensions/story_extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/stories_swiper.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_progress_bar.dart';
import 'package:ion/app/hooks/use_on_init.dart';

PageController usePageControllerWithInitialPage(int initialPage) {
  final initialPageRef = useRef<int>(initialPage);
  final controller = useMemoized(() => PageController(initialPage: initialPage), []);
  useEffect(() => controller.dispose, [controller]);

  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients && initialPageRef.value != initialPage) {
          controller.jumpToPage(initialPage);
          initialPageRef.value = initialPage;
        }
      });
      return null;
    },
    [initialPage],
  );

  return controller;
}

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingController = ref.read(storyViewingControllerProvider.notifier);
    final storyViewingState = ref.watch(storyViewingControllerProvider);

    useOnInit(storyViewingController.loadStories);

    final userPageController = usePageControllerWithInitialPage(0);

    useEffect(
      () {
        storyViewingState.maybeWhen(
          ready: (users, currentUserIndex, _) {
            if (userPageController.hasClients) {
              userPageController.jumpToPage(currentUserIndex);
            }
          },
          orElse: () {},
        );
        return null;
      },
      [storyViewingState],
    );

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
            ready: (ready) {
              return Stack(
                children: [
                  StoriesSwiper(
                    userPageController: userPageController,
                    users: ready.users,
                    currentUserIndex: ready.currentUserIndex,
                    currentStoryIndex: ready.currentStoryIndex,
                    onUserPageChanged: storyViewingController.moveToUser,
                    onStoryPageChanged: storyViewingController.moveToStoryIndex,
                    onNextStory: storyViewingController.moveToNextStory,
                    onPreviousStory: storyViewingController.moveToPreviousStory,
                  ),
                  Positioned(
                    bottom: 28.0.s,
                    left: 0,
                    right: 0,
                    child: StoryProgressBar(
                      totalStories: ready.users[ready.currentUserIndex].stories.length,
                      currentIndex: ready.currentStoryIndex,
                      onStoryCompleted: () {
                        final state = ref.read(storyViewingControllerProvider);
                        final controller = ref.read(storyViewingControllerProvider.notifier);

                        if (state.hasNextStory) {
                          controller.moveToNextStory();
                        } else if (state.hasNextUser) {
                          userPageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.pop();
                        }
                      },
                    ),
                  ),
                  ScreenBottomOffset(margin: 16.0.s),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
