// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart'
    show filteredStoriesByPubkeyProvider;
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';

import '../../../../fixtures/factories/post_factory.dart';
import '../../../../robots/stories/story_viewer_robot.dart';
import '../helpers/story_test_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();
  registerStoriesFallbacks();

  const myPubkey = 'alice';
  const otherPubkey = 'bob';

  final myStories = UserStories(
    pubkey: myPubkey,
    stories: [
      makePost('a1', author: myPubkey),
      makePost('a2', author: myPubkey),
    ],
  );

  final otherStories = UserStories(
    pubkey: otherPubkey,
    stories: [
      makePost('b1', author: otherPubkey),
    ],
  );

  group('Own stories viewer', () {
    testWidgets('horizontal swipe does not switch to another user', (tester) async {
      final robot = await StoryViewerRobot.launch(
        tester,
        stories: [myStories, otherStories],
        viewerPubkey: myPubkey,
        extraOverrides: [
          filteredStoriesByPubkeyProvider(myPubkey).overrideWith((_) => [myStories]),
        ],
      );

      robot.expectUserIndex(0);
      await robot.swipeToNextUser();
      robot.expectUserIndex(0);
    });
  });
}
