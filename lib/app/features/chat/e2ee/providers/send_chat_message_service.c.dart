import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_chat_message_service.c.g.dart';

@riverpod
Future<SendChatMessageService> sendChatMessageService(Ref ref) async {
  return SendChatMessageService(
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider),
    sendChatMessageService: await ref.watch(sendE2eeMessageServiceProvider.future),
    getExistingConversationId: (String pubkey) =>
        ref.read(existChatConversationIdProvider(pubkey).future),
  );
}

class SendChatMessageService {
  SendChatMessageService({
    required this.currentUserMasterPubkey,
    required this.sendChatMessageService,
    required this.getExistingConversationId,
  });

  final String? currentUserMasterPubkey;
  final SendE2eeMessageService sendChatMessageService;
  final Future<String?> Function(String pubkey) getExistingConversationId;

  Future<void> send({
    required String receiverPubkey,
    required String content,
    List<MediaFile> mediaFiles = const [],
  }) async {
    final currentPubkey = currentUserMasterPubkey;

    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final existingConversationId = await getExistingConversationId(receiverPubkey);

    final conversationId = existingConversationId ?? generateUuid();

    await sendChatMessageService.sendMessage(
      conversationId: conversationId,
      content: content,
      mediaFiles: mediaFiles,
      participantsMasterPubkeys: [receiverPubkey, currentPubkey],
    );
  }
}
