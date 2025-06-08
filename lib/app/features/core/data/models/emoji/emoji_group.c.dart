// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/data/models/emoji/emoji_data.c.dart';

part 'emoji_group.c.freezed.dart';
part 'emoji_group.c.g.dart';

@freezed
class EmojiGroup with _$EmojiGroup {
  const factory EmojiGroup({
    required String name,
    required String slug,
    required List<EmojiData> emojis,
  }) = _EmojiGroup;

  factory EmojiGroup.fromJson(Map<String, dynamic> json) => _$EmojiGroupFromJson(json);
}
