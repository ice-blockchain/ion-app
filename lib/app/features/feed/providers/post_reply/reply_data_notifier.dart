// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_data_notifier.g.dart';
part 'reply_data_notifier.freezed.dart';

@freezed
class PostReplyState with _$PostReplyState {
  const factory PostReplyState({
    required String text,
  }) = _PostReplyState;

  factory PostReplyState.empty() => const PostReplyState(
        text: '',
      );
}

@riverpod
class ReplyDataNotifier extends _$ReplyDataNotifier {
  @override
  PostReplyState build() {
    return PostReplyState.empty();
  }

  void onTextChanged(String newValue) {
    state = state.copyWith(text: newValue);
  }

  void clear() {
    state = PostReplyState.empty();
  }
}
