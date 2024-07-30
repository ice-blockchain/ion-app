import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_reply_request_notifier.g.dart';

@riverpod
class SendReplyRequestNotifier extends _$SendReplyRequestNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> sendReply() async {
    state = AsyncValue.loading();
    await Future<void>.delayed(Duration(seconds: 1));
    state = AsyncValue.data(null);
  }
}
