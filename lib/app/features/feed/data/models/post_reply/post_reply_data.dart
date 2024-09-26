import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_reply_data.freezed.dart';

@Freezed(copyWith: true)
class PostReplyData with _$PostReplyData {
  const factory PostReplyData({
    required String text,
  }) = _PostReplyData;

  factory PostReplyData.empty() => const PostReplyData(
        text: '',
      );
}
