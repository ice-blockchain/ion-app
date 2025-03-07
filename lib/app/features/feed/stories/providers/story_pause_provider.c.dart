// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_pause_provider.c.g.dart';

@riverpod
class StoryPauseController extends _$StoryPauseController {
  @override
  bool build() => false;

  set paused(bool value) => state = value;
}

@riverpod
class StoryMenuController extends _$StoryMenuController {
  @override
  bool build() => false;

  set menuOpen(bool value) => state = value;
}
