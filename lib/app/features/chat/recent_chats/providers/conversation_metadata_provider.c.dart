// SPDX-License-Identifier: ice License 1.0

// // SPDX-License-Identifier: ice License 1.0

// import 'package:collection/collection.dart';
// import 'package:ion/app/exceptions/exceptions.dart';
// import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
// import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
// import 'package:ion/app/features/chat/model/chat_type.dart';
// import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
// import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
// import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'conversation_metadata_provider.c.g.dart';

// @riverpod
// class ConversationMetadata extends _$ConversationMetadata {
//   @override
//   Future<ConversationEntity> build(ConversationEntity conversation) async {
//     state = const AsyncValue.loading();

//     final currentMasterPubkey = await ref.watch(currentPubkeySelectorProvider.future);

//     if (currentMasterPubkey == null) {
//       throw UserMasterPubkeyNotFoundException();
//     }

//     final database = ref.read(conversationsDBServiceProvider);
//     final unreadMessagesCount = await database.unreadMessagesCount(
//       conversationId: conversation.id,
//       masterPubkey: currentMasterPubkey,
//     );

//     if (conversation.type == ChatType.oneOnOne) {
//       final masterPubkey =
//           conversation.participantsMasterkeys.firstWhereOrNull((key) => key != currentMasterPubkey);

//       if (masterPubkey == null) {
//         throw UserMetadataNotFoundException(masterPubkey ?? '?');
//       }

//       final userMetadata = await ref.watch(userMetadataProvider(masterPubkey).future);

//       if (userMetadata == null) {
//         throw UserMetadataNotFoundException(masterPubkey);
//       }

//       final nickname = userMetadata.data.name;
//       final name = userMetadata.data.displayName;
//       final imageUrl = userMetadata.data.picture;

//       return ConversationEntity(
//         name: name,
//         nickname: nickname,
//         imageUrl: imageUrl,
//         unreadMessagesCount: unreadMessagesCount,
//         participantsMasterkeys: conversation.participantsMasterkeys,
//         id: conversation.id,
//         type: conversation.type,
//         isArchived: conversation.isArchived,
//         lastMessageAt: conversation.lastMessageAt,
//         lastMessageContent: conversation.lastMessageContent,
//       );
//     } else {
//       var imageUrl = conversation.imageUrl;
//       // If the image is not available, download it from the server and update conversation messages
//       if (conversation.imageUrl == null) {
//         final conversationMessages = await database.getConversationMessages(conversation.id);
//         final latestMessageWithIMetaTag =
//             conversationMessages.firstWhereOrNull((m) => m.data.primaryMedia != null);

//         final conversationMessageManagementService =
//             await ref.read(conversationMessageManagementServiceProvider.future);

//         if (latestMessageWithIMetaTag != null) {
//           final imageUrls = await conversationMessageManagementService
//               .downloadDecryptDecompressMedia([latestMessageWithIMetaTag.data.primaryMedia!]);

//           imageUrl = imageUrls.single.path;

//           await database.updateGroupConversationImage(
//             groupImagePath: imageUrl,
//             conversationId: conversation.id,
//           );
//         }
//       }

//       return ConversationEntity(
//         imageUrl: imageUrl,
//         unreadMessagesCount: unreadMessagesCount,
//         id: conversation.id,
//         name: conversation.name,
//         type: conversation.type,
//         isArchived: conversation.isArchived,
//         participantsMasterkeys: conversation.participantsMasterkeys,
//         lastMessageAt: conversation.lastMessageAt,
//         lastMessageContent: conversation.lastMessageContent,
//       );
//     }
//   }
// }
