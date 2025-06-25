// SPDX-License-Identifier: ice License 1.0

<<<<<<<< HEAD:lib/app/features/user_profile/providers/user_metadata_from_db_provider.r.dart
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user_metadata/database/dao/user_metadata_dao.m.dart';
========
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user_profile/database/dao/user_metadata_dao.c.dart';
>>>>>>>> d3ecb7764 (feat: add delegation to profile db):lib/app/features/user_profile/providers/user_metadata_from_db_provider.c.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_from_db_provider.r.g.dart';

@riverpod
class UserMetadataFromDbNotifier extends _$UserMetadataFromDbNotifier {
  @override
  UserMetadataEntity? build(String masterPubkey) {
    ref.watch(userMetadataDaoProvider).get(masterPubkey).then((metadata) {
      state = metadata;
    });

    final subscription = ref.watch(userMetadataDaoProvider).watch(masterPubkey).listen((metadata) {
      state = metadata;
    });

    ref.onDispose(subscription.cancel);

    return null;
  }
}
