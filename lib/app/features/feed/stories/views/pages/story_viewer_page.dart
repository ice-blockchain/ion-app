// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/hooks/use_page_dismiss.dart';
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
      [storyViewerState.userStories.length],
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

    final drag = usePageDismiss(context);

    return Material(
      color: Colors.transparent,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.theme.appColors.primaryText,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: GestureDetector(
          onVerticalDragUpdate: drag.onDragUpdate,
          onVerticalDragEnd: drag.onDragEnd,
          child: Transform.translate(
            offset: Offset(0, drag.offset),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: context.theme.appColors.primaryText,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: StoriesSwiper(
                        pubkey: pubkey,
                        userStories: storyViewerState.userStories,
                        currentUserIndex: storyViewerState.currentUserIndex,
                      ),
                    ),
                    SizedBox(height: 28.0.s),
                    StoryProgressBarContainer(pubkey: pubkey),
                    ScreenBottomOffset(margin: 16.0.s),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
