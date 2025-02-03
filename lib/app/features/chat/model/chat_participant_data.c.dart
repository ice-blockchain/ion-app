// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_participant_data.c.freezed.dart';

@freezed
class ChatParticipantData with _$ChatParticipantData {
  const factory ChatParticipantData({
    required String? pubkey,
    required String masterPubkey,
  }) = _ChatParticipantData;

  const ChatParticipantData._();
}
