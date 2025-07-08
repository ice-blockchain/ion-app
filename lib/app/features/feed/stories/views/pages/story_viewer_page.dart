// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/stories_references.f.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/hooks/use_preload_story_image.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/video/views/hooks/use_status_bar_color.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/hooks/use_route_presence.dart';

class StoryViewerPage extends HookConsumerWidget {
  const StoryViewerPage({
    required this.pubkey,
    this.initialStoryReference,
    this.showOnlySelectedUser = false,
    super.key,
  });

  final String pubkey;
  final EventReference? initialStoryReference;
  final bool showOnlySelectedUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStatusBarColor();

    final storyViewerState = ref
        .watch(storyViewingControllerProvider(pubkey, showOnlySelectedUser: showOnlySelectedUser));
    final stories =
        ref.watch(userStoriesProvider(storyViewerState.currentStory?.pubkey ?? pubkey))?.toList() ??
            [];
    final storiesReferences = StoriesReferences(stories.map((e) => e.toEventReference()));
    final viewedStories = ref.watch(viewedStoriesControllerProvider(storiesReferences));

    useOnInit(
      () {
        if (storyViewerState.userStories.isEmpty && context.mounted && context.canPop()) {
          context.pop();
        }
      },
      [storyViewerState.userStories.isEmpty],
    );

    useOnInit(
      () async {
        final firstNotViewedStoryIndex =
            stories.indexWhere((story) => !viewedStories.contains(story.toEventReference()));
        final initialStoryIndex = initialStoryReference != null
            ? stories.indexWhere((story) => story.toEventReference() == initialStoryReference)
            : null;
        if (initialStoryIndex != null || firstNotViewedStoryIndex != -1) {
          ref
              .watch(
                storyViewingControllerProvider(pubkey, showOnlySelectedUser: showOnlySelectedUser)
                    .notifier,
              )
              .moveToStoryIndex(initialStoryIndex ?? firstNotViewedStoryIndex);
        }
      },
      [stories.isEmpty, viewedStories],
    );

    useRoutePresence(
      onBecameInactive: () => ref.read(storyPauseControllerProvider.notifier).paused = true,
      onBecameActive: () => ref.read(storyPauseControllerProvider.notifier).paused = false,
    );

    final currentStory = stories.elementAtOrNull(storyViewerState.currentStoryIndex);
    useOnInit(
      () {
        if (currentStory != null) {
          ref
              .read(viewedStoriesControllerProvider(storiesReferences).notifier)
              .markStoryAsViewed(currentStory);
        }
      },
      [currentStory?.id],
    );

    useOnInit(
      () {
        final currentUserStoriesLeft = stories.length - storyViewerState.currentStoryIndex - 1;
        if (currentUserStoriesLeft < 10) {
          ref.read(userStoriesProvider(storyViewerState.nextUserPubkey));
        }
      },
      [storyViewerState.currentStoryIndex],
    );

    usePreloadStoryImage(ref, stories.elementAtOrNull(storyViewerState.currentStoryIndex + 1));

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
            // Prevent story's content from shrinking on keyboard open
            data: media
                .removeViewInsets(removeBottom: true)
                .removeViewPadding(removeBottom: true, removeTop: true),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
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
