// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_message_list_item_provider.c.g.dart';

@riverpod
class RepliedMessageListItem extends _$RepliedMessageListItem {
  @override
  Future<EventMessage?> build(ChatMessageInfoItem messageItem) async {
    final entity = PrivateDirectMessageEntity.fromEventMessage(messageItem.eventMessage);

    RelatedEvent? relatedEvent;

    if (entity.data.relatedEvents?.length == 1) {
      relatedEvent = entity.data.relatedEvents!.first;
    } else {
      relatedEvent = entity.data.relatedEvents
          ?.firstWhereOrNull((event) => event.marker != RelatedEventMarker.root);
    }

    if (relatedEvent != null) {
      final repliedMessageEvent = await ref.watch(conversationMessageDaoProvider).getEventMessage(
            ref: ref,
            messageId: (relatedEvent as RelatedImmutableEvent).eventReference.eventId,
          );

      return repliedMessageEvent;
    }

    return null;
  }
}
