// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user_profile/database/dao/user_metadata_dao.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_from_db_provider.r.g.dart';

@riverpod
class UserMetadataFromDbNotifier extends _$UserMetadataFromDbNotifier {
  @override
  UserMetadataEntity? build(String masterPubkey) {
    keepAliveWhenAuthenticated(ref);
    final subscription = ref.watch(userMetadataDaoProvider).watch(masterPubkey).listen((metadata) {
      state = metadata;
    });

    ref.onDispose(subscription.cancel);

    return null;
  }
}
