// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_viewer_page.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import '../../../../fixtures/factories/post_factory.dart';
import '../../../../mocks.dart';
import '../../../../robots/stories/story_viewer_robot.dart';
import '../helpers/story_test_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();

  final aliceStories = UserStories(
    pubkey: 'alice',
    stories: [makePost('a1', author: 'alice'), makePost('a2', author: 'alice')],
  );
  final bobStories = UserStories(
    pubkey: 'bob',
    stories: [makePost('b1', author: 'bob'), makePost('b2', author: 'bob')],
  );

  setUpAll(registerStoriesFallbacks);

  setUp(() async {
    SharedPreferencesStorePlatform.instance = InMemorySharedPreferencesStore.empty();
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    required List<UserStories> stories,
    String initialPubkey = 'alice',
  }) async {
    const identity = 'test_identity';
    final mockStorage = MockLocalStorage();

    when(() => mockStorage.setStringList(any(), any<List<String>>())).thenAnswer((_) async => true);
    when(() => mockStorage.getStringList(any())).thenReturn(null);

    final testRouter = GoRouter(
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
          goRouterProvider.overrideWith((_) => testRouter),
        ],
        child: ContentScaler(
          child: MaterialApp.router(
            routerConfig: testRouter,
            localizationsDelegates: I18n.localizationsDelegates,
            supportedLocales: I18n.supportedLocales,
            locale: const Locale('en'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('StoryViewerPage – gestures', () {
    testWidgets('horizontal swipe switches user', (tester) async {
      await pumpPage(tester, stories: [aliceStories, bobStories]);

      final robot = StoryViewerRobot(tester, viewerPubkey: 'alice');

      await robot.swipeToNextUser();

      robot.expectUserIndex(1);
    });

    testWidgets('tap right / left switches stories inside user', (tester) async {
      await pumpPage(tester, stories: [aliceStories]);

      final robot = StoryViewerRobot(tester, viewerPubkey: 'alice');

      await robot.tapNextStory();
      robot.expectStoryIndex(1);

      await robot.tapPreviousStory();
      robot.expectStoryIndex(0);
    });

    testWidgets('long-press pauses and resumes after release', (tester) async {
      await pumpPage(tester, stories: [aliceStories]);

      final robot = StoryViewerRobot(tester, viewerPubkey: 'alice');
      final container = ProviderScope.containerOf(
        tester.element(find.byType(StoryViewerPage)),
      );

      final pauseSub = container.listen<bool>(
        storyPauseControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );

      final gesture = await robot.startPressCenter();
      await tester.pump(const Duration(milliseconds: 600));
      expect(pauseSub.read(), isTrue, reason: 'Viewer should be paused');

      await robot.releasePress(gesture);
      expect(pauseSub.read(), isFalse, reason: 'Viewer should be resumed');
    });
  });
}
