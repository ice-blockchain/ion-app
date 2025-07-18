// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/user_chat_relays.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.r.g.dart';

@riverpod
Future<UserChatRelaysEntity?> userChatRelays(
  Ref ref, {
  required String pubkey,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(
        masterPubkey: pubkey,
        kind: UserChatRelaysEntity.kind,
      ),
    ).future,
  ) as UserChatRelaysEntity?;
}
