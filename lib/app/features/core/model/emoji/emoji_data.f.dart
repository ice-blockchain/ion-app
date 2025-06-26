// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_data.f.freezed.dart';
part 'emoji_data.f.g.dart';

@freezed
class EmojiData with _$EmojiData {
  const factory EmojiData({
    required String emoji,
    @JsonKey(name: 'skin_tone_support') required bool skinToneSupport,
    required String name,
    required String slug,
    @JsonKey(name: 'unicode_version') required String unicodeVersion,
    @JsonKey(name: 'emoji_version') required String emojiVersion,
  }) = _EmojiData;

  factory EmojiData.fromJson(Map<String, dynamic> json) => _$EmojiDataFromJson(json);
}
