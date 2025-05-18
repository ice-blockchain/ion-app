// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';

import '../base_robot.dart';
import '../mixins/provider_scope_mixin.dart';
import '../mixins/story_state_mixin.dart';

class StoryProgressBarRobot extends BaseRobot with ProviderScopeMixin, StoryStateMixin {
  StoryProgressBarRobot(
    super.tester, {
    required this.viewerPubkey,
  });

  final String viewerPubkey;

  static Future<StoryProgressBarRobot> launch(
    WidgetTester tester, {
    required List<UserStories> stories,
    required String viewerPubkey,
  }) async {
    await ScreenUtil.ensureScreenSize();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storiesProvider.overrideWith((_) => stories),
          filteredStoriesByPubkeyProvider(viewerPubkey).overrideWith((_) => stories),
        ],
        child: ContentScaler(
          child: MaterialApp(
            home: Scaffold(
              body: StoryProgressBarContainer(pubkey: viewerPubkey),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    return StoryProgressBarRobot(tester, viewerPubkey: viewerPubkey);
  }

  Finder get _segmentFinder => find.byType(StoryProgressSegment);
  Finder get _containerFinder => find.byType(StoryProgressBarContainer);

  ProviderContainer get _container => getContainerFromFinder(_containerFinder);

  void advance() =>
      _container.read(storyViewingControllerProvider(viewerPubkey).notifier).advance();

  List<StoryProgressSegment> get segments =>
      tester.widgetList<StoryProgressSegment>(_segmentFinder).toList();

  void expectSegmentCount(int expected) =>
      expect(segments.length, expected, reason: 'segment count');

  void expectSegmentState({
    required int index,
    required bool isCurrent,
    required bool isPrevious,
  }) {
    final segment = segments[index];
    expect(segment.isCurrent, isCurrent, reason: 'segments[$index].isCurrent');
    expect(
      segment.isPreviousStory,
      isPrevious,
      reason: 'segments[$index].isPreviousStory',
    );
  }

  @override
  void expectViewerState({
    required int userIndex,  
    required int storyIndex,
  }) {
    verifyViewerState(
      viewerPubkey: viewerPubkey,
      container: _container,
      userIndex: userIndex,
      storyIndex: storyIndex,
    );
  }
}
