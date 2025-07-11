// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';

part 'chat_search_result_item.f.freezed.dart';

@freezed
class ChatSearchResultItem with _$ChatSearchResultItem {
  const factory ChatSearchResultItem({
    required UserMetadataEntity userMetadata,
    String? lastMessageContent,
  }) = _ChatSearchResultItem;
}
