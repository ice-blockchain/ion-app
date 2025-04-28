// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_bar_container.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_segment.dart';

import '../helpers/story_test_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();

  const viewerPubkey = 'alice';

  final viewerStories = UserStories(
    pubkey: viewerPubkey,
    stories: [buildPost('s1'), buildPost('s2')],
  );

  setUpAll(registerStoriesFallbacks);

  Future<void> pumpViewer(
    WidgetTester tester, {
    required List<UserStories> stories,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storiesProvider.overrideWith((_) => stories),
          filteredStoriesByPubkeyProvider(viewerPubkey).overrideWith((_) => stories),
        ],
        child: const ContentScaler(
          child: MaterialApp(
            home: Scaffold(
              body: StoryProgressBarContainer(pubkey: viewerPubkey),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  group('StoryProgressBarContainer', () {
    testWidgets('renders N segments for N stories', (tester) async {
      await pumpViewer(tester, stories: [viewerStories]);

      final segments = tester.widgetList<StoryProgressSegment>(find.byType(StoryProgressSegment));

      expect(segments.length, 2);
    });

    testWidgets(
      'after advance(): previous segment marked completed, next marked current',
      (tester) async {
        await pumpViewer(tester, stories: [viewerStories]);

        final containerElement = tester.element(find.byType(StoryProgressBarContainer));
        final providerContainer = ProviderScope.containerOf(containerElement);

        providerContainer.read(storyViewingControllerProvider(viewerPubkey).notifier).advance();

        await tester.pump();

        final segments =
            tester.widgetList<StoryProgressSegment>(find.byType(StoryProgressSegment)).toList();

        final first = segments.first;
        final second = segments[1];

        expect(
          first.isPreviousStory,
          isTrue,
          reason: 'first segment should be marked as completed',
        );
        expect(
          second.isCurrent,
          isTrue,
          reason: 'second segment should be marked as current',
        );
      },
    );

    testWidgets(
      'advance() past last story moves to next user with storyIndex 0',
      (tester) async {
        // stories: viewer (alice) – 2 stories, bob – 2 more stories
        final bobStories = UserStories(
          pubkey: 'bob',
          stories: [buildPost('b1', author: 'bob'), buildPost('b2', author: 'bob')],
        );

        await pumpViewer(tester, stories: [viewerStories, bobStories]);

        final element = tester.element(find.byType(StoryProgressBarContainer));
        final container = ProviderScope.containerOf(element);

        // Step 1: on alice/s1  →  advance() → alice/s2
        // Step 2: advance()     → bob/b1  (storyIndex should become 0)
        container.read(storyViewingControllerProvider(viewerPubkey).notifier)
          ..advance()
          ..advance();

        await tester.pump();

        final state = container.read(storyViewingControllerProvider(viewerPubkey));
        expect(state.currentUserIndex, 1); // switched to Bob
        expect(state.currentStoryIndex, 0); // first story of Bob

        final segments =
            tester.widgetList<StoryProgressSegment>(find.byType(StoryProgressSegment)).toList();

        expect(segments.length, 2); // for Bob draw 2 segments
        expect(segments.first.isCurrent, isTrue); // current – first
        expect(segments[1].isCurrent, isFalse);
        expect(segments[1].isPreviousStory, isFalse);
      },
    );
  });
}
