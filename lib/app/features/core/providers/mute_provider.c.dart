// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mute_provider.c.g.dart';

@Riverpod(keepAlive: true)
class GlobalMute extends _$GlobalMute {
  @override
  bool build() => true;

  void toggle() => state = !state;

  set muted(bool muteState) => state = muteState;
}
