// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.f.dart';
import 'package:ion/app/features/ion_connect/model/deletable_event.dart';

part 'conversation_to_delete.f.freezed.dart';

@freezed
class ConversationToDelete with _$ConversationToDelete implements DeletableEvent {
  const factory ConversationToDelete(String conversationId) = _ConversationToDelete;

  const ConversationToDelete._();

  @override
  List<List<String>> toTags() => [
        [ConversationIdentifier.tagName, conversationId],
      ];
}
