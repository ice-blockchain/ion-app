// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/user_file_storage_relays.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_file_storage_relay_provider.r.g.dart';

@riverpod
Future<UserFileStorageRelaysEntity?> userFileStorageRelay(
  Ref ref, {
  required String pubkey,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(
        pubkey: pubkey,
        kind: UserFileStorageRelaysEntity.kind,
      ),
    ).future,
  ) as UserFileStorageRelaysEntity?;
}
