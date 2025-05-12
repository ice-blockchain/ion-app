// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_viewer_page.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../helpers/fake_video_platform.dart';
import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';
import '../helpers/story_test_video.dart';

class _MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();
  registerStoriesFallbacks();

  setUp(() async {
    SharedPreferencesStorePlatform.instance = InMemorySharedPreferencesStore.empty();
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  const alice = 'alice';
  final lastVideoPost = buildPost('vid_last', mediaType: MediaType.video);
  final aliceStories = UserStories(pubkey: alice, stories: [lastVideoPost]);

  const videoDuration = Duration(seconds: 3);
  final fakeCtrl = FakeVideoController(videoDuration);
  VideoPlayerPlatform.instance = FakeVideoPlayerPlatform();

  final mockStorage = _MockLocalStorage();
  when(() => mockStorage.getStringList(any())).thenReturn(<String>[]);
  when(() => mockStorage.setStringList(any(), any<List<String>>())).thenAnswer((_) async => true);

  testWidgets('StoryViewerPage pops after the very last story', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold()),
        GoRoute(
          path: '/viewer',
          builder: (_, __) => const StoryViewerPage(pubkey: alice),
        ),
      ],
      initialLocation: '/',
    );

    await pumpWithOverrides(
      tester,
      child: ContentScaler(
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: I18n.localizationsDelegates,
          supportedLocales: I18n.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
      overrides: [
        storiesProvider.overrideWith((_) => [aliceStories]),
        filteredStoriesByPubkeyProvider(alice).overrideWith((_) => [aliceStories]),
        videoPlayerControllerFactoryProvider('dummy')
            .overrideWith((_) => FakeVideoFactory(fakeCtrl)),
        localStorageProvider.overrideWithValue(mockStorage),
        userPreferencesServiceProvider(identityKeyName: alice)
            .overrideWith((_) => UserPreferencesService(alice, mockStorage)),
        goRouterProvider.overrideWithValue(router),
      ],
    );

    unawaited(router.push('/viewer'));
    await tester.pumpAndSettle();
    expect(find.byType(StoryViewerPage), findsOneWidget);

    fakeCtrl
      ..value = fakeCtrl.value.copyWith(position: videoDuration)
      ..notifyListeners();

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(StoryViewerPage), findsNothing);
  });
}
