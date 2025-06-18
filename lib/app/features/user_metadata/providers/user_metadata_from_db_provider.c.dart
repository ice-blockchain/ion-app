// SPDX-License-Identifier: ice License 1.0


import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user_metadata/database/dao/user_metadata_dao.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_from_db_provider.c.g.dart';

@riverpod
class UserMetadataFromDbNotifier extends _$UserMetadataFromDbNotifier {
  @override
  UserMetadataEntity? build(String masterPubkey) {
    ref.watch(userMetadataDaoProvider).get(masterPubkey).then((metadata) {
      state = metadata;
    });

    final subscription = ref.watch(userMetadataDaoProvider).watch(masterPubkey).listen((metadata) {
      if (metadata != null) {
        state = metadata;
      }
    });

    ref.onDispose(subscription.cancel);

    return null;
  }
}
