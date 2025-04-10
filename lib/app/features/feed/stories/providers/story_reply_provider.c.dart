// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_reply_provider.c.g.dart';

@riverpod
class StoryReply extends _$StoryReply {
  @override
  FutureOr<void> build() {}

  Future<void> sendReaction() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(seconds: 2));
    state = const AsyncData(null);
  }

  void sendReplyMessage() {}
}
