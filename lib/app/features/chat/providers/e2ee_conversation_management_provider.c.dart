// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_nip44_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_conversation_management_provider.c.g.dart';

@riverpod
class E2eeConversationManagement extends _$E2eeConversationManagement {
  @override
  Future<void> build() async {}

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

  Future<void> toggleArchiveConversations(List<E2eeConversationEntity> conversations) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);
      final nip44Service = await ref.read(ionConnectNip44ServiceProvider.future);
      final currentUserPubkey = await ref.read(currentPubkeySelectorProvider.future);

      if (currentUserPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final archivedConversationBookmarksSet = bookmarksMap[BookmarksSetType.chats];
      final allBookmarksSetsData = bookmarksMap.map((key, value) => MapEntry(key, value?.data));

      var existingArchiveBookmarks = <List<String>>[];

      if (archivedConversationBookmarksSet != null) {
        final decryptedBookmarkSetContent = await nip44Service.decryptMessage(
          archivedConversationBookmarksSet.data.content,
        );

        existingArchiveBookmarks = (jsonDecode(decryptedBookmarkSetContent) as List<dynamic>)
            .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
            .toList();
      }

      final newArchiveBookmarks = List<List<String>>.from(existingArchiveBookmarks);

      for (final conversation in conversations) {
        if (conversation.type == ChatType.chat) {
          final conversationBookmark = ['p', conversation.participants[0]];
          if (!existingArchiveBookmarks.any((e) => e.equals(conversationBookmark))) {
            newArchiveBookmarks.add(conversationBookmark);
          } else {
            newArchiveBookmarks.removeWhere((e) => e.equals(conversationBookmark));
          }
        } else if (conversation.type == ChatType.group) {
          final participantsSorted = List<String>.from(conversation.participants)..sort();
          final conversationBookmark = [
            'subject',
            conversation.name,
            ...participantsSorted,
          ];

          if (!existingArchiveBookmarks.any((e) => e.equals(conversationBookmark))) {
            newArchiveBookmarks.add(conversationBookmark);
          } else {
            newArchiveBookmarks.removeWhere((e) => e.equals(conversationBookmark));
          }
        }
      }

      final encodedContent = jsonEncode(newArchiveBookmarks);

      final encryptedContent = await nip44Service.encryptMessage(encodedContent);

      final newSingleBookmarksSetData = BookmarksSetData(
        postsIds: [],
        articlesRefs: [],
        content: encryptedContent,
        type: BookmarksSetType.chats,
        communitiesIds: archivedConversationBookmarksSet?.data.communitiesIds ?? [],
      );

      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: allBookmarksSetsData.values
            .map((data) => data?.toReplaceableEventReference(currentUserPubkey))
            .nonNulls
            .toList(),
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([newSingleBookmarksSetData, bookmarksData]);
    });
  }

  Future<void> readConversations(List<String> conversationIds) async {
    await ref.read(conversationsDBServiceProvider).markConversationsAsRead(conversationIds);
  }

  Future<void> readAllConversations() async {
    await ref.read(conversationsDBServiceProvider).markAllConversationsAsRead();
  }
}
