// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/model/contact_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_by_pubkey_provider.c.g.dart';

@riverpod
Future<ContactData> contactByPubkey(Ref ref, String pubkey) async {
  final userMetadata = await ref.watch(userMetadataProvider(pubkey).future);

  return ContactData(
    pubkey: userMetadata!.masterPubkey,
    name: userMetadata.data.displayName,
    icon: userMetadata.data.picture!,
    nickname: userMetadata.data.name,
  );
}
