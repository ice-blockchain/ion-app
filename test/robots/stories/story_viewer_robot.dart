// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_viewer_page.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../base_robot.dart';

typedef _GestureHandler = StoryGestureHandler;

class StoryViewerRobot extends BaseRobot {
  StoryViewerRobot(
    super.tester, {
    required this.viewerPubkey,
  });

  final String viewerPubkey;

  static Future<StoryViewerRobot> launch(
    WidgetTester tester, {
    required List<UserStories> stories,
    required String viewerPubkey,
    String identity = 'test_user',
    List<Override> extraOverrides = const [],
  }) async {
    await _pumpViewer(
      tester: tester,
      stories: stories,
      initialPubkey: viewerPubkey,
      identity: identity,
      extraOverrides: extraOverrides,
    );
    return StoryViewerRobot(tester, viewerPubkey: viewerPubkey);
  }

  static Future<void> _pumpViewer({
    required WidgetTester tester,
    required List<UserStories> stories,
    required String initialPubkey,
    required String identity,
    List<Override> extraOverrides = const [],
  }) async {
    final mockStorage = MockLocalStorage();

    when(() => mockStorage.setStringList(any(), any<List<String>>())).thenAnswer((_) async => true);
    when(() => mockStorage.getStringList(any())).thenReturn(null);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SizedBox()),
        GoRoute(
          path: '/viewer',
          builder: (_, __) => StoryViewerPage(pubkey: initialPubkey),
        ),
      ],
      initialLocation: '/viewer',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storiesProvider.overrideWith((_) => stories),
          currentIdentityKeyNameSelectorProvider.overrideWith((_) => identity),
          localStorageProvider.overrideWithValue(mockStorage),
          userPreferencesServiceProvider(identityKeyName: identity)
              .overrideWith((_) => UserPreferencesService(identity, mockStorage)),
          goRouterProvider.overrideWith((_) => router),
          ...extraOverrides,
        ],
        child: ContentScaler(
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: I18n.localizationsDelegates,
            supportedLocales: I18n.supportedLocales,
            locale: const Locale('en'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Finder get _swiper => find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == 'StoriesSwiper',
      );

  Finder get _gesture => find.byKey(ValueKey('story_gesture_$viewerPubkey'));

  ProviderContainer get _container => ProviderScope.containerOf(tester.element(_gesture));

  Future<void> swipeToNextUser() async {
    await tester.fling(_swiper, const Offset(-600, 0), 1000);
    await tester.pumpAndSettle();
  }

  Future<void> swipeToPreviousUser() async {
    await tester.fling(_swiper, const Offset(600, 0), 1000);
    await tester.pumpAndSettle();
  }

  Future<void> tapNextStory() async {
    final handler = tester.widget<_GestureHandler>(_gesture);
    handler.onTapRight();
    await tester.pump();
  }

  Future<void> tapPreviousStory() async {
    final handler = tester.widget<_GestureHandler>(_gesture);
    handler.onTapLeft();
    await tester.pump();
  }

  Future<void> longPressCenter({
    Duration duration = const Duration(milliseconds: 600),
  }) async {
    final gesture = await startPressCenter();
    await tester.pump(duration);
    await releasePress(gesture);
  }

  Future<TestGesture> startPressCenter() async {
    final rect = tester.getRect(_gesture);
    final center = rect.center;
    final gesture = await tester.startGesture(center);
    await tester.pump();
    return gesture;
  }

  Future<void> releasePress(TestGesture gesture) async {
    await gesture.up();
    await tester.pumpAndSettle();
  }

  void expectStoryIndex(int index) {
    final state = _container.read(storyViewingControllerProvider(viewerPubkey));
    expect(
      state.currentStoryIndex,
      index,
      reason: 'Expected currentStoryIndex == $index',
    );
  }

  void expectUserIndex(int index) {
    final state = _container.read(storyViewingControllerProvider(viewerPubkey));
    expect(
      state.currentUserIndex,
      index,
      reason: 'Expected currentUserIndex == $index',
    );
  }

  Future<void> _tapFractional(Offset fraction) async {
    final rect = tester.getRect(_gesture);
    final position = Offset(
      rect.left + rect.width * fraction.dx,
      rect.top + rect.height * fraction.dy,
    );
    await tester.tapAt(position);
    await tester.pumpAndSettle();
  }
}
