// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notifier.g.dart';

@riverpod
class RepostNotifier extends _$RepostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> repost({required String eventId}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {});
  }
}
