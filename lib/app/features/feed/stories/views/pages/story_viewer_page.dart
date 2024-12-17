// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/hooks/use_page_dismiss.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
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
    final storyState = ref.watch(storyViewingControllerProvider);
    final stories = ref.watch(filteredStoriesByPubkeyProvider(pubkey));

    useOnInit(() => ref.read(storyViewingControllerProvider.notifier).updateStories(stories));

    useRoutePresence(
      onBecameInactive: () => ref.read(storyPauseControllerProvider.notifier).paused = true,
      onBecameActive: () => ref.read(storyPauseControllerProvider.notifier).paused = false,
    );

    final drag = usePageDismiss(context);

    return Hero(
      tag: 'story-$pubkey',
      child: Material(
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
                  child: storyState.userStories.isEmpty
                      ? const CenteredLoadingIndicator()
                      : Column(
                          children: [
                            Expanded(
                              child: StoriesSwiper(
                                userStories: storyState.userStories,
                                currentUserIndex: storyState.currentUserIndex,
                              ),
                            ),
                            SizedBox(height: 28.0.s),
                            const StoryProgressBarContainer(),
                            ScreenBottomOffset(margin: 16.0.s),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
