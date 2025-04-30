// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/hooks/use_route_presence.dart';

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();

    final storyViewerState = ref.watch(storyViewingControllerProvider(pubkey));

    useOnInit(
      () {
        if (storyViewerState.userStories.isEmpty && context.mounted && context.canPop()) {
          context.pop();
        }
      },
      [storyViewerState.userStories.isEmpty],
    );

    useRoutePresence(
      onBecameInactive: () => ref.read(storyPauseControllerProvider.notifier).paused = true,
      onBecameActive: () => ref.read(storyPauseControllerProvider.notifier).paused = false,
    );

    final currentStory = storyViewerState.currentStory;
    useOnInit(
      () {
        if (currentStory != null) {
          ref.read(viewedStoriesControllerProvider.notifier).markStoryAsViewed(currentStory.id);
        }
      },
      [currentStory?.id],
    );

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        final media = MediaQuery.of(context);
        final fixedTop = MediaQuery.paddingOf(context).top;
        final size = MediaQuery.sizeOf(context);
        final footerHeight = 82.0.s;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: context.theme.appColors.primaryText,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: MediaQuery(
            data: media
                .removeViewInsets(removeBottom: true)
                .removeViewPadding(removeBottom: true, removeTop: true),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: context.theme.appColors.primaryText,
              body: Stack(
                children: [
                  PositionedDirectional(
                    top: fixedTop,
                    width: size.width,
                    height: size.height - fixedTop - footerHeight,
                    child: StoriesSwiper(
                      pubkey: pubkey,
                      userStories: storyViewerState.userStories,
                      currentUserIndex: storyViewerState.currentUserIndex,
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 0,
                    height: footerHeight,
                    child: AnimatedOpacity(
                      opacity: isKeyboardVisible ? 0 : 1,
                      duration: const Duration(milliseconds: 150),
                      child: IgnorePointer(
                        ignoring: isKeyboardVisible,
                        child: ColoredBox(
                          color: context.theme.appColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 0,
                    height: footerHeight,
                    child: IgnorePointer(
                      ignoring: isKeyboardVisible,
                      child: AnimatedOpacity(
                        opacity: isKeyboardVisible ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 28.0.s),
                            StoryProgressBarContainer(pubkey: pubkey),
                            ScreenBottomOffset(margin: 16.0.s),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
