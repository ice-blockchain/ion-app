// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archive_state_provider.r.g.dart';

@Riverpod(keepAlive: true)
class ArchiveState extends _$ArchiveState {
  @override
  bool build() => false;

  set value(bool value) {
    state = value;
  }
}
