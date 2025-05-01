// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_video_playback.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

import '../../app/features/stories/helpers/story_test_video.dart';
import '../base_robot.dart';

class _PlaybackHost extends HookConsumerWidget {
  const _PlaybackHost({required this.post, required this.viewerPubkey});

  final ModifiablePostEntity post;
  final String viewerPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref
        .watch(
          videoControllerProvider(
            const VideoControllerParams(sourcePath: 'dummy', authorPubkey: 'alice'),
          ),
        )
        .value;

    useStoryVideoPlayback(
      ref: ref,
      controller: ctrl,
      storyId: post.id,
      viewerPubkey: viewerPubkey,
      onCompleted: () => ref.read(storyViewingControllerProvider(viewerPubkey).notifier).advance(),
    );

    return const SizedBox.shrink();
  }
}

class VideoPlaybackRobot extends BaseRobot {
  VideoPlaybackRobot(
    super.tester, {
    required this.post,
    required this.viewerPubkey,
    required Duration duration,
  }) : _fake = FakeVideoController(duration);

  final ModifiablePostEntity post;
  final String viewerPubkey;
  final FakeVideoController _fake;

  Finder get _hostFinder => find.byType(_PlaybackHost);

  ProviderContainer get _container => ProviderScope.containerOf(tester.element(_hostFinder));

  Override get videoOverride => videoPlayerControllerFactoryProvider('dummy').overrideWith(
        (_) => FakeVideoFactory(_fake),
      );

  Widget buildHost() => _PlaybackHost(post: post, viewerPubkey: viewerPubkey);

  Future<void> completeVideo() async {
    _fake
      ..value = _fake.value.copyWith(position: _fake.value.duration)
      ..notifyListeners();
    await tester.pump();
  }

  void expectViewerState({required int user, required int story}) {
    final state = _container.read(storyViewingControllerProvider(viewerPubkey));
    expect(state.currentUserIndex, user, reason: 'currentUserIndex');
    expect(state.currentStoryIndex, story, reason: 'currentStoryIndex');
  }
}
