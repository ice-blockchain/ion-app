import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_type_provider.c.g.dart';

@riverpod
Future<ConversationType> conversationType(
  Ref ref,
  String? conversationId,
  String? receiverPubKey,
) async {
  if (receiverPubKey != null) {
    return ConversationType.oneToOne;
  }

  if (conversationId == null) {
    throw ConversationTypeNotFoundException();
  }

  final conversationType =
      await ref.watch(conversationDaoProvider).getConversationType(conversationId);

  if (conversationType == null) {
    throw ConversationTypeNotFoundException();
  }

  return conversationType;
}
