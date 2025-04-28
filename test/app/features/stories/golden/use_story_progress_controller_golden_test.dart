// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress_controller.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:mocktail/mocktail.dart';

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

class _MockPost extends Mock implements ModifiablePostEntity {}

ModifiablePostEntity _buildPost(MediaType t) {
  final p = _MockPost();
  when(() => p.id).thenReturn('post_${t.name}');
  when(() => p.masterPubkey).thenReturn('alice');
  when(() => p.data).thenReturn(_FakePostData(t));
  return p;
}

class _FakeVideoController extends ValueNotifier<CachedVideoPlayerPlusValue>
    implements CachedVideoPlayerPlusController {
  _FakeVideoController(Duration d) : super(const CachedVideoPlayerPlusValue.uninitialized()) {
    value = value.copyWith(isInitialized: true, duration: d, position: Duration.zero);
  }

  @override
  DataSourceType get dataSourceType => DataSourceType.asset;

  @override
  Future<void> play() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> seekTo(Duration p) async => value = value.copyWith(position: p);

  @override
  Future<void> dispose() async => super.dispose();

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _FakeFactory extends VideoPlayerControllerFactory {
  _FakeFactory(this._ctrl) : super(sourcePath: 'dummy');
  final CachedVideoPlayerPlusController _ctrl;

  @override
  CachedVideoPlayerPlusController createController(VideoPlayerOptions? _) => _ctrl;
}

class _TestFlag {
  static bool completed = false;
}

class _StoryConsumer extends HookConsumerWidget {
  const _StoryConsumer({required this.post});
  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useStoryProgressController(
      ref: ref,
      post: post,
      isCurrent: true,
      isPaused: false,
      onCompleted: () => _TestFlag.completed = true,
    );
    return const SizedBox.shrink();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('useStoryProgressController – golden', () {
    testWidgets('image story completes after 5 s', (tester) async {
      final post = _buildPost(MediaType.image);
      _TestFlag.completed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: _StoryConsumer(post: post)),
        ),
      );

      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(_StoryConsumer)));
      container.read(storyImageLoadStatusProvider(post.id).notifier).markLoaded();

      await tester.pumpAndSettle(const Duration(seconds: 6));

      expect(_TestFlag.completed, isTrue);
    });

    testWidgets('video story completes when position == duration', (tester) async {
      const dur = Duration(seconds: 3);
      final post = _buildPost(MediaType.video);
      final fakeCtrl = _FakeVideoController(dur);
      _TestFlag.completed = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            videoPlayerControllerFactoryProvider('dummy')
                .overrideWith((_) => _FakeFactory(fakeCtrl)),
          ],
          child: MaterialApp(home: _StoryConsumer(post: post)),
        ),
      );

      await tester.pump();

      fakeCtrl
        ..value = fakeCtrl.value.copyWith(position: dur)
        ..notifyListeners();

      await tester.pump();

      expect(_TestFlag.completed, isTrue);
    });
  });
}
