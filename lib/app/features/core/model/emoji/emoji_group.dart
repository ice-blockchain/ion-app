// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/emoji/emoji_data.dart';

part 'emoji_group.freezed.dart';
part 'emoji_group.g.dart';

@freezed
class EmojiGroup with _$EmojiGroup {
  const factory EmojiGroup({
    required String name,
    required String slug,
    required List<EmojiData> emojis,
  }) = _EmojiGroup;

  factory EmojiGroup.fromJson(Map<String, dynamic> json) => _$EmojiGroupFromJson(json);
}
