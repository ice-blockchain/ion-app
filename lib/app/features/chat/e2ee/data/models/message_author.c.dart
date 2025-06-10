// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

part 'message_author.c.freezed.dart';

@freezed
class MessageAuthor with _$MessageAuthor {
  const factory MessageAuthor({
    // TODO: Should be pubkey, but commented since unnecessary for now
    // required String id,
    required String name,
    String? imageUrl,
    @Default(false) bool isApproved,
    @Default(false) bool isIceUser,
    @Default(false) bool isCurrentUser,
    MediaFile? image,
  }) = _MessageAuthor;
}
