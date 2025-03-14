// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'private_message_reaction_data.c.freezed.dart';

@immutable
@Freezed(equal: false)
class PrivateMessageReactionEntity with _$PrivateMessageReactionEntity {
  const factory PrivateMessageReactionEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required PrivateMessageReactionEntityData data,
  }) = _PrivateMessageReactionEntity;

  const PrivateMessageReactionEntity._();

  factory PrivateMessageReactionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return PrivateMessageReactionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: PrivateMessageReactionEntityData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 7;

  static const String likeSymbol = '+';

  @override
  bool operator ==(Object other) {
    return other is PrivateMessageReactionEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

@freezed
class PrivateMessageReactionEntityData with _$PrivateMessageReactionEntityData {
  const factory PrivateMessageReactionEntityData({
    required String pubkey,
    required String content,
    required String eventId,
  }) = _PrivateMessageReactionEntityData;

  const PrivateMessageReactionEntityData._();

  factory PrivateMessageReactionEntityData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final kind = tags['k']?.first[1];
    final eventId = tags['e']?.first[1];
    final pubkey = tags['p']?.first[1];

    if (eventId == null || pubkey == null || kind != PrivateDirectMessageEntity.kind.toString()) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return PrivateMessageReactionEntityData(
      eventId: eventId,
      pubkey: pubkey,
      content: eventMessage.content,
    );
  }
}
