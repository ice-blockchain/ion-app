import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:uuid/uuid.dart';

String generateConversationId({
  required ConversationType conversationType,
  List<String> receiverMasterPubkeys = const [],
}) {
  final sorted = List<String>.from(receiverMasterPubkeys)..sort();

  // For one-to-one conversations, we use v5 UUID to ensure the same conversation ID for the same participants.
  if (conversationType == ConversationType.oneToOne) {
    return const Uuid().v5(Namespace.nil.value, sorted.join());
  } else if (conversationType == ConversationType.group) {
    return const Uuid().v7();
  } else if (conversationType == ConversationType.community) {
    return const Uuid().v7();
  } else {
    throw UnsupportedError('Unsupported conversation type: $conversationType');
  }
}
