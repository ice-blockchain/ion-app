// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mute_provider.g.dart';

@riverpod
class GlobalMute extends _$GlobalMute {
  @override
  bool build() => false;

  void toggle() => state = !state;

  set muted(bool muteState) => state = muteState;
}
