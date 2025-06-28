// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/model/user_delegation.f.dart';
import 'package:ion/app/features/user_profile/database/dao/user_delegation_dao.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_delegation_from_db_provider.r.g.dart';

@riverpod
class UserDelegationFromDbNotifier extends _$UserDelegationFromDbNotifier {
  @override
  UserDelegationEntity? build(String masterPubkey) {
    ref.watch(userDelegationDaoProvider).get(masterPubkey).then((delegation) {
      state = delegation;
    });

    final subscription =
        ref.watch(userDelegationDaoProvider).watch(masterPubkey).listen((delegation) {
      state = delegation;
    });

    ref.onDispose(subscription.cancel);

    return null;
  }
}
