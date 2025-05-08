// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_pubkeys_provider.c.g.dart';

@riverpod
class ConversationPubkeys extends _$ConversationPubkeys {
  @override
  Future<void> build() async {}

  Future<Map<String, List<String>>> fetchUsersKeys(List<String> masterPubkeys) async {
    final usersKeys = <String, List<String>>{};

    for (final masterPubkey in masterPubkeys) {
      final delegation = await ref.read(userDelegationProvider(masterPubkey).future);
      if (delegation == null) {
        continue;
      }

      final pubkeys = delegation.data.delegates.map((delegate) => delegate.pubkey).toList();
      usersKeys.addAll({masterPubkey: pubkeys});
    }
    return usersKeys;
  }
}
