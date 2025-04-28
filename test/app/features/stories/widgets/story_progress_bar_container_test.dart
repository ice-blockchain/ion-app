// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_bar_container.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/progress/story_progress_segment.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:mocktail/mocktail.dart';

class _MockPost extends Mock implements ModifiablePostEntity {}

class _FakeAttachment extends Fake implements MediaAttachment {
  _FakeAttachment(this.mediaType);
  @override
  final MediaType mediaType;
  @override
  String get url => 'dummy';
}

class _FakePostData extends Fake implements ModifiablePostData {
  _FakePostData(this.mediaType);
  final MediaType mediaType;
  @override
  Map<String, MediaAttachment> get media => {'0': _FakeAttachment(mediaType)};
  @override
  MediaAttachment? get primaryMedia => _FakeAttachment(mediaType);
}

ModifiablePostEntity _post(String id) {
  final p = _MockPost();
  when(() => p.id).thenReturn(id);
  when(() => p.masterPubkey).thenReturn('alice');
  when(() => p.data).thenReturn(_FakePostData(MediaType.image));
  return p;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();

  const pubkey = 'alice';
  final userStories = UserStories(
    pubkey: pubkey,
    stories: [_post('s1'), _post('s2')],
  );

  setUpAll(() {
    registerFallbackValue(_FakeAttachment(MediaType.image));
    registerFallbackValue(_FakePostData(MediaType.image));
  });

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
