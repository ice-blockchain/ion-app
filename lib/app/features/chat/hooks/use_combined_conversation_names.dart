// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

String? useCombinedConversationNames(
  List<ConversationListItem> conversations,
  WidgetRef ref,
) {
  final future = useMemoized(
    () async {
      final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

      final names = <String>[];
      for (final conversation in conversations) {
        if (conversation.type == ConversationType.oneToOne) {
          final latestMessageEntity =
              ReplaceablePrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);

          final receiver = latestMessageEntity.relatedPubkeys!
              .firstWhere((pubkey) => pubkey.value != currentUserMasterPubkey)
              .value;

          final userMetadata = await ref.read(userMetadataProvider(receiver).future);
          if (userMetadata != null) {
            names.add(userMetadata.data.displayName);
          }
        } else if (conversation.type == ConversationType.community) {
          final community =
              await ref.read(communityMetadataProvider(conversation.conversationId).future);
          names.add(community.data.name);
        } else {
          final latestMessageEntity =
              ReplaceablePrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);
          names.add(latestMessageEntity.groupSubject?.value ?? '');
        }
      }
      return names.join(', ');
    },
    conversations,
  );

  final snapshot = useFuture(future);
  return snapshot.data;
}
