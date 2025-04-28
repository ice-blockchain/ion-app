// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';

class FakeVideoController extends ValueNotifier<CachedVideoPlayerPlusValue>
    implements CachedVideoPlayerPlusController {
  FakeVideoController(Duration duration) : super(const CachedVideoPlayerPlusValue.uninitialized()) {
    value = value.copyWith(
      isInitialized: true,
      duration: duration,
      position: Duration.zero,
    );
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

class FakeVideoFactory extends VideoPlayerControllerFactory {
  FakeVideoFactory(this.controller) : super(sourcePath: 'dummy');

  final CachedVideoPlayerPlusController controller;

  @override
  CachedVideoPlayerPlusController createController(VideoPlayerOptions? _) => controller;
}
