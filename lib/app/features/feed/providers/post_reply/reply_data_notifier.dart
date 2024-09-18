import 'package:ice/app/features/feed/data/models/post_reply/post_reply_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_data_notifier.g.dart';

@riverpod
class ReplyDataNotifier extends _$ReplyDataNotifier {
  @override
  PostReplyData build() {
    return PostReplyData.empty();
  }

  void onTextChanged(String newValue) {
    state = state.copyWith(text: newValue);
  }

  void clear() {
    state = PostReplyData.empty();
  }
}
