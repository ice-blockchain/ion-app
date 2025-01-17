// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_conversation_management_provider.c.g.dart';

@riverpod
class E2EEConversationManagement extends _$E2EEConversationManagement {
  @override
  FutureOr<void> build() {}

  Future<void> createOneOnOneConversation(
    List<String> participantsPubkeys,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final conversationMessageManagementService = await ref.read(conversationMessageManagementServiceProvider);

      await conversationMessageManagementService.sentMessage(
        content: '',
        participantsPubkeys: participantsPubkeys,
      );
    });
  }

  Future<void> createGroup({
    required String subject,
    required MediaFile groupImage,
    required List<String> participantsPubkeys,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final conversationMessageManagementService = await ref.read(conversationMessageManagementServiceProvider);

      await conversationMessageManagementService.sentMessage(
        content: '',
        subject: subject,
        mediaFiles: [groupImage],
        participantsPubkeys: participantsPubkeys,
      );
    });
  }

  Future<void> addParticipant(
    String conversationSubject,
    String participantPubkey,
  ) async {
    assert(conversationSubject.isNotEmpty, 'Conversation subject is empty');
    assert(participantPubkey.isNotEmpty, 'Participant pubkey is empty');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final databaseService = ref.read(conversationsDBServiceProvider);
      final conversationMessageManagementService = await ref.read(conversationMessageManagementServiceProvider);

      final conversationsEventMessages = await databaseService.getAllConversations();

      final conversationsEntities =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final pubkeys = conversationsEntities
              .singleWhere(
                (e) => e.data.relatedSubject?.value == conversationSubject,
                orElse: () => throw ConversationNotFoundException(),
              )
              .data
              .relatedPubkeys
              ?.map((e) => e.value)
              .toList() ??
          [];

      await conversationMessageManagementService.sentMessage(
        content: '',
        subject: conversationSubject,
        participantsPubkeys: pubkeys..add(participantPubkey),
      );
    });
  }

  Future<void> removeParticipant(
    String conversationSubject,
    String participantPubkey,
  ) async {
    assert(conversationSubject.isNotEmpty, 'Conversation subject is empty');
    assert(participantPubkey.isNotEmpty, 'Participant pubkey is empty');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final databaseService = ref.read(conversationsDBServiceProvider);
      final conversationMessageManagementService = await ref.read(conversationMessageManagementServiceProvider);

      final conversationsEventMessages = await databaseService.getAllConversations();

      final conversationsEntities =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final pubkeys = conversationsEntities
              .singleWhere(
                (e) => e.data.relatedSubject?.value == conversationSubject,
                orElse: () => throw ConversationNotFoundException(),
              )
              .data
              .relatedPubkeys
              ?.map((e) => e.value)
              .toList() ??
          [];

      if (!pubkeys.contains(participantPubkey)) {
        throw ParticipantNotFoundException();
      }

      await conversationMessageManagementService.sentMessage(
        content: '',
        subject: conversationSubject,
        participantsPubkeys: pubkeys..remove(participantPubkey),
      );
    });
  }

  Future<void> changeSubject(
    String currentSubject,
    String newSubject,
  ) async {
    assert(currentSubject.isNotEmpty, 'Current conversation subject is empty');
    assert(newSubject.isNotEmpty, 'New conversation subject is empty');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final databaseService = ref.read(conversationsDBServiceProvider);
      final conversationMessageManagementService = await ref.read(conversationMessageManagementServiceProvider);

      final conversationsEventMessages = await databaseService.getAllConversations();

      final conversationsEntities =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final pubkeys = conversationsEntities
              .singleWhere(
                (e) => e.data.relatedSubject?.value == currentSubject,
                orElse: () => throw ConversationNotFoundException(),
              )
              .data
              .relatedPubkeys
              ?.map((e) => e.value)
              .toList() ??
          [];

      await conversationMessageManagementService.sentMessage(
        content: '',
        subject: newSubject,
        participantsPubkeys: pubkeys,
      );
    });
  }

  Future<void> deleteConversations(List<String> ids) async {
    final databaseService = ref.read(conversationsDBServiceProvider);

    for (final id in ids) {
      await databaseService.deleteConversation(id);
    }
  }

  Future<void> readConversations(List<String> conversationIds) async {
    await ref.read(conversationsDBServiceProvider).markConversationsAsRead(conversationIds);
  }

  Future<void> readAllConversations() async {
    await ref.read(conversationsDBServiceProvider).markAllConversationsAsRead();
  }
}
