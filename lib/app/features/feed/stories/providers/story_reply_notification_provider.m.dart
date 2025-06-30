// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_reply_notification_provider.m.g.dart';
part 'story_reply_notification_provider.m.freezed.dart';

@freezed
class StoryReplyNotificationState with _$StoryReplyNotificationState {
  const factory StoryReplyNotificationState({
    String? selectedEmoji,
    @Default(false) bool showNotification,
  }) = _StoryReplyNotificationState;
}

@riverpod
class StoryReplyNotificationController extends _$StoryReplyNotificationController {
  @override
  StoryReplyNotificationState build() => const StoryReplyNotificationState();

  void showNotification({String? emoji}) {
    state = state.copyWith(
      selectedEmoji: emoji,
      showNotification: true,
    );
  }

  void hideNotification() {
    state = state.copyWith(
      selectedEmoji: null,
      showNotification: false,
    );
  }
}
