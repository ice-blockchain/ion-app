import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_current_user_event_provider.c.g.dart';

@riverpod
Future<bool> isCurrentUserEvent(Ref ref, EventMessage eventMessage) async {
  switch (eventMessage.kind) {
    case PrivateDirectMessageEntity.kind:
      final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
      return eventMessage.pubkey == eventSigner?.publicKey;
    case ModifiablePostEntity.kind:
      return ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    default:
      throw UnimplementedError(
        'Event kind ${eventMessage.kind} is not supported to check if it is the current user',
      );
  }
}
