// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

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
    required String content,
    required ReplaceableEventReference reference,
  }) = _PrivateMessageReactionEntityData;

  const PrivateMessageReactionEntityData._();

  factory PrivateMessageReactionEntityData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    final identifierTag = tags[ReplaceableEventReference.tagName]?.first;

    if (identifierTag == null) {
      throw IncorrectEventTagsException(eventId: eventMessage.id);
    }

    return PrivateMessageReactionEntityData(
      content: eventMessage.content,
      reference: ReplaceableEventReference.fromTag(identifierTag),
    );
  }
}
