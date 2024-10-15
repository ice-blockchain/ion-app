// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_reply_data.freezed.dart';

@freezed
class PostReplyData with _$PostReplyData {
  const factory PostReplyData({
    required String text,
  }) = _PostReplyData;

  factory PostReplyData.empty() => const PostReplyData(
        text: '',
      );
}
