// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_pubkeys_provider.c.g.dart';

@riverpod
class ConversationPubkeys extends _$ConversationPubkeys {
  @override
  Future<void> build() async {}

  Future<Map<String, String>> fetchUsersKeys(List<String> masterPubkeys) async {
    final usersKeys = <String, String>{};
    final users = await _fetchUsersMetadata(masterPubkeys);

    for (final user in users) {
      usersKeys.addAll({user.masterPubkey: user.pubkey});
    }
    return usersKeys;
  }

  Future<List<UserMetadataEntity>> _fetchUsersMetadata(List<String> masterPubkeys) async {
    final result = <UserMetadataEntity>[];

    for (final masterPubkey in masterPubkeys) {
      final userMetadata = await ref.watch(userMetadataProvider(masterPubkey).future);

      if (userMetadata != null) {
        result.add(userMetadata);
      }
    }

    return result;
  }
}
