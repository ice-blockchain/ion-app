import 'package:ice/app/features/feed/providers/post_reply/reply_data_notifier.dart';
import 'package:ice/app/services/async_response/async_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_reply_request_notifier.g.dart';

@riverpod
class SendReplyRequestNotifier extends _$SendReplyRequestNotifier {
  @override
  AsyncResponse<void> build() {
    return AsyncResponse.initial();
  }

  Future<void> sendReply() async {
    state = AsyncResponse.loading();

    // send reply
    await Future<void>.delayed(Duration(seconds: 1));
    ref.read(replyDataNotifierProvider.notifier).clear();

    state = AsyncResponse.success(null);
  }
}
