// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_management_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<ConversationManagementService> conversationManagementService(
  Ref ref,
) async {
  final databaseService = ref.watch(conversationsDBServiceProvider);
  final conversationMessageManagementService =
      ref.watch(conversationMessageManagementServiceProvider).requireValue;

  return ConversationManagementService(
    databaseService: databaseService,
    conversationMessageManagementService: conversationMessageManagementService,
  );
}

class ConversationManagementService {
  ConversationManagementService({
    required this.databaseService,
    required this.conversationMessageManagementService,
  });

  final ConversationsDBService databaseService;
  final ConversationMessageManagementService conversationMessageManagementService;

  Future<void> addParticipant(
    String conversationSubject,
    String participantPubkey,
  ) async {
    assert(conversationSubject.isNotEmpty, 'Conversation subject is empty');
    assert(participantPubkey.isNotEmpty, 'Participant pubkey is empty');

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
  }

  Future<void> removeParticipant(
    String conversationSubject,
    String participantPubkey,
  ) async {
    assert(conversationSubject.isNotEmpty, 'Conversation subject is empty');
    assert(participantPubkey.isNotEmpty, 'Participant pubkey is empty');

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
  }

  Future<void> changeSubject(
    String currentSubject,
    String newSubject,
  ) async {
    assert(currentSubject.isNotEmpty, 'Current conversation subject is empty');
    assert(newSubject.isNotEmpty, 'New conversation subject is empty');

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
  }
}
