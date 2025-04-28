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

  const pubkey = 'alice';
  final userStories = UserStories(
    pubkey: pubkey,
    stories: [buildPost('s1'), buildPost('s2')],
  );

  setUpAll(registerStoriesFallbacks);

  Future<void> pumpContainer(
    WidgetTester tester, {
    required List<UserStories> stories,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storiesProvider.overrideWith((_) => stories),
          filteredStoriesByPubkeyProvider(pubkey).overrideWith((_) => stories),
        ],
        child: const ContentScaler(
          child: MaterialApp(
            home: Scaffold(
              body: StoryProgressBarContainer(pubkey: pubkey),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('renders N segments for N stories', (tester) async {
    await pumpContainer(tester, stories: [userStories]);

    final segments = tester.widgetList<StoryProgressSegment>(
      find.byType(StoryProgressSegment),
    );

    expect(segments.length, 2);
  });

  testWidgets('marks previous segment as completed after moving to next story', (tester) async {
    await pumpContainer(tester, stories: [userStories]);

    final element = tester.element(find.byType(StoryProgressBarContainer));
    final container = ProviderScope.containerOf(element);

    container.read(storyViewingControllerProvider(pubkey).notifier).moveToNextStory();
    await tester.pump();

    final segmentsAfter = tester
        .widgetList<StoryProgressSegment>(
          find.byType(StoryProgressSegment),
        )
        .toList();

    final first = segmentsAfter.first;
    final second = segmentsAfter[1];

    expect(first.isPreviousStory, isTrue, reason: 'First segment should be marked as read');
    expect(second.isCurrent, isTrue, reason: 'Second segment is the current story');
  });
}
