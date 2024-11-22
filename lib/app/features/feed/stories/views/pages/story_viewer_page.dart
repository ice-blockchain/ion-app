// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyViewingController =
        ref.watch(storyViewingControllerProvider(startingPubkey: pubkey).notifier);
    final storyState = ref.watch(storyViewingControllerProvider(startingPubkey: pubkey));

    final currentPauseState = useState(false);
    final userPageController = usePageController();

    useEffect(
      () {
        if (userPageController.hasClients) {
          userPageController.jumpToPage(storyState.currentUserIndex);
        }
        return null;
      },
      [storyState],
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
          child: Column(
            children: [
              Expanded(
                child: StoriesSwiper(
                  userPageController: userPageController,
                  userStories: storyState.userStories,
                  currentUserIndex: storyState.currentUserIndex,
                  currentStoryIndex: storyState.currentStoryIndex,
                  onUserPageChanged: storyViewingController.moveToUser,
                  onStoryPageChanged: storyViewingController.moveToStoryIndex,
                  onNextStory: storyViewingController.moveToNextStory,
                  onPreviousStory: storyViewingController.moveToPreviousStory,
                  onPausedChanged: (paused) => currentPauseState.value = paused,
                ),
              ),
              SizedBox(height: 28.0.s),
              StoryProgressBarContainer(
                posts: storyState.userStories[storyState.currentUserIndex].stories,
                currentStoryIndex: storyState.currentStoryIndex,
                onStoryCompleted: () {
                  if (storyState.hasNextStory) {
                    storyViewingController.moveToNextStory();
                  } else if (storyState.hasNextUser) {
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
          ),
        ),
      ),
    );
  }
}
