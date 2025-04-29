// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/stories_swiper.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_viewer_page.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../helpers/story_test_models.dart';

class _FakeEventRef extends Fake implements ReplaceableEventReference {}

ModifiablePostEntity _post(String id, String author) {
  final post = buildPost(id, author: author);
  when(post.toEventReference).thenReturn(_FakeEventRef());
  return post;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();

  // Demo data
  final aliceStories = UserStories(
    pubkey: 'alice',
    stories: [_post('a1', 'alice'), _post('a2', 'alice')],
  );
  final bobStories = UserStories(
    pubkey: 'bob',
    stories: [_post('b1', 'bob'), _post('b2', 'bob')],
  );

  setUpAll(registerStoriesFallbacks);

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
        GoRoute(path: '/viewer', builder: (_, __) => StoryViewerPage(pubkey: initialPubkey)),
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

      final container = ProviderScope.containerOf(tester.element(find.byType(StoryViewerPage)));

      await tester.fling(find.byType(StoriesSwiper), const Offset(-600, 0), 1000);
      await tester.pumpAndSettle();

      expect(container.read(storyViewingControllerProvider('alice')).currentUserIndex, 1);
    });

    testWidgets('tap right / left switches stories inside user', (tester) async {
      await pumpPage(tester, stories: [aliceStories]);

      final handlerFinder = find.byKey(const ValueKey('story_gesture_alice'));
      var handlerWidget = tester.widget<StoryGestureHandler>(handlerFinder);

      final container = ProviderScope.containerOf(tester.element(find.byType(StoryViewerPage)));

      handlerWidget.onTapRight();
      await tester.pump();
      expect(container.read(storyViewingControllerProvider('alice')).currentStoryIndex, 1);

      handlerWidget = tester.widget<StoryGestureHandler>(handlerFinder);
      handlerWidget.onTapLeft();
      await tester.pump();
      expect(container.read(storyViewingControllerProvider('alice')).currentStoryIndex, 0);
    });

    testWidgets('long-press pauses and resumes after release', (tester) async {
      await pumpPage(tester, stories: [aliceStories]);

      final handler = find.byType(StoryGestureHandler);
      final element = tester.element(handler);
      final container = ProviderScope.containerOf(element);

      final pauseSub = container.listen<bool>(
        storyPauseControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );

      final size = tester.getSize(handler);
      final center = Offset(size.width / 2, size.height / 2);

      final gesture = await tester.startGesture(center);
      await tester.pump(const Duration(milliseconds: 600));
      expect(pauseSub.read(), isTrue);

      await gesture.up();
      await tester.pump();
      expect(pauseSub.read(), isFalse);
    });
  });
}
