import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_status_provider.c.g.dart';

@Riverpod(keepAlive: true)
Raw<Stream<MessageDeliveryStatus>> messageStatus(
  Ref ref, {
  required EventReference eventReference,
}) {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    return const Stream.empty();
  }

  return ref.watch(conversationMessageDataDaoProvider).messageStatus(
        eventReference: eventReference,
        currentUserMasterPubkey: currentUserMasterPubkey,
      );
}
