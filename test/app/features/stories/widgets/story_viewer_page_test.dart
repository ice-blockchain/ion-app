// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import '../../../../fixtures/factories/post_factory.dart';
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

  group('StoryViewerPage – gestures', () {
    testWidgets('horizontal swipe switches user', (tester) async {
      final robot = await StoryViewerRobot.launch(
        tester,
        stories: [aliceStories, bobStories],
        viewerPubkey: 'alice',
      );

      await robot.swipeToNextUser();

      robot.expectUserIndex(1);
    });

    testWidgets('tap right / left switches stories inside user', (tester) async {
      final robot = await StoryViewerRobot.launch(
        tester,
        stories: [aliceStories],
        viewerPubkey: 'alice',
      );

      await robot.tapNextStory();
      robot.expectStoryIndex(1);

      await robot.tapPreviousStory();
      robot.expectStoryIndex(0);
    });

    testWidgets('long-press pauses and resumes after release', (tester) async {
      final robot = await StoryViewerRobot.launch(
        tester,
        stories: [aliceStories],
        viewerPubkey: 'alice',
      );

      final pauseSub = robot.container.listen<bool>(
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
