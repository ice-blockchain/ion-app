// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/channel_data.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/group.dart';
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<RecentChatDataModel>> build() async {
    state = const AsyncValue.loading();
    try {
      final data = await Future.delayed(const Duration(seconds: 1), () {
        return mockConversationData;
      });
      state = AsyncValue.data(data);
      return data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
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
      return List<RecentChatDataModel>.unmodifiable(newData);
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
      return List<RecentChatDataModel>.unmodifiable(newData);
    });
  }
}
