// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingController = ref.read(storyViewingControllerProvider.notifier);
    final storyViewingState = ref.watch(storyViewingControllerProvider);

    final currentPauseState = useState(false);

    useOnInit(() {
      storyViewingController.loadStories(startingPubkey: pubkey);
    });

    final userPageController = usePageController();

    useEffect(
      () {
        storyViewingState.whenOrNull(
          ready: (users, currentUserIndex, _) {
            if (userPageController.hasClients) {
              userPageController.jumpToPage(currentUserIndex);
            }
          },
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
          child: storyViewingState.maybeWhen(
            orElse: () => const CenteredLoadingIndicator(),
            ready: (users, currentUserIndex, currentStoryIndex) {
              final currentUser = users[currentUserIndex];
              return Column(
                children: [
                  Expanded(
                    child: StoriesSwiper(
                      userPageController: userPageController,
                      users: users,
                      currentUserIndex: currentUserIndex,
                      currentStoryIndex: currentStoryIndex,
                      onUserPageChanged: storyViewingController.moveToUser,
                      onStoryPageChanged: storyViewingController.moveToStoryIndex,
                      onNextStory: storyViewingController.moveToNextStory,
                      onPreviousStory: storyViewingController.moveToPreviousStory,
                      onPausedChanged: (paused) => currentPauseState.value = paused,
                    ),
                  ),
                  SizedBox(height: 28.0.s),
                  StoryProgressBarContainer(
                    stories: currentUser.stories,
                    currentStoryIndex: currentStoryIndex,
                    onStoryCompleted: () {
                      if (storyViewingState.hasNextStory) {
                        storyViewingController.moveToNextStory();
                      } else if (storyViewingState.hasNextUser) {
                        userPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.pop();
                      }
                    },
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
