// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_data.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/group.c.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<PrivateDirectMessageEntity>> build() async {
    final conversationSubscription = ref
        .read(iONDatabaseNotifierProvider.notifier)
        .watchConversations()
        .listen((conversationsEventMessages) async {
      final data =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      state = AsyncValue.data(data);
    });

    ref.onDispose(conversationSubscription.cancel);

    state = const AsyncValue.loading();
    try {
      final database = ref.read(iONDatabaseNotifierProvider.notifier);
      final conversationsEventMessages = await database.getAllConversations();

      final conversationsList =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();
      state = AsyncValue.data(conversationsList);
      return conversationsList;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> watchConversations() async {
    ref
        .read(iONDatabaseNotifierProvider.notifier)
        .watchConversations()
        .listen((conversationsEventMessages) async {
      final data = await _mapConversations(conversationsEventMessages);

      state = AsyncValue.data(data);
    });
  }

  Future<List<RecentChatDataModel>> _mapConversations(
    List<EventMessage> conversationsEventMessages,
  ) async {
    return Future.wait(
      conversationsEventMessages.map((eventMessage) async {
        late String subject;
        final participants = eventMessage.pubkeysList;

        // One-to-one conversation
        if (participants.length == 2) {
          final conversationMetadata =
              ref.watch(userMetadataProvider(eventMessage.pubkey)).valueOrNull;

          // Display name of another user
          subject = conversationMetadata?.data.displayName ?? '';

          return RecentChatDataModel(
            MessageAuthor(
              name: subject,
              // TODO: Change to real image from user metadata once we will get real pubkeys
              imageUrl: 'https://x.com/ice_blockchain/photo',
            ),
            0,
            TextRecentChatMessage(
              eventMessage.content,
              eventMessage.createdAt,
            ),
            eventMessage.id,
          );
          // Small group conversation
        } else {
          // Group subject taken from the last message of the conversation
          subject = eventMessage.subject ?? '';

          return RecentChatDataModel(
            MessageAuthor(
              name: subject,
              // TODO Change to real image from group metadata
              imageUrl: 'https://x.com/ice_blockchain/photo',
            ),
            0,
            TextRecentChatMessage(
              eventMessage.content,
              eventMessage.createdAt,
            ),
            eventMessage.id,
          );
        }
      }),
    );
  }

  void addChannelConversation(ChannelData channelData) {
    update((currentData) {
      final newConversation = RecentChatDataModel(
        MessageAuthor(
          name: channelData.name,
          imageUrl: 'https://x.com/ice_blockchain/photo',
          isApproved: true,
        ),
        1,
        TextRecentChatMessage(
          'The channel has been created',
          DateTime.now(),
        ),
        channelData.id,
        type: ChatType.channel,
      );
      final newData = [
        newConversation,
        ...currentData,
      ];
      return List<PrivateDirectMessageEntity>.unmodifiable(newData);
    });
  }

  void addGroupConversation(Group group) {
    update((currentData) {
      final newConversation = RecentChatDataModel(
        MessageAuthor(
          name: group.name,
          imageUrl: 'https://x.com/ice_blockchain/photo',
          isApproved: true,
        ),
        1,
        TextRecentChatMessage(
          'The group has been created',
          DateTime.now(),
        ),
        group.id,
        type: ChatType.group,
      );
      final newData = [
        newConversation,
        ...currentData,
      ];
      return List<PrivateDirectMessageEntity>.unmodifiable(newData);
    });
  }
}
