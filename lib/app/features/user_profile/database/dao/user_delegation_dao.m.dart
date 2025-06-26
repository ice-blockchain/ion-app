// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user_profile/database/tables/user_delegation_table.c.dart';
import 'package:ion/app/features/user_profile/database/user_profile_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_delegation_dao.m.g.dart';

@riverpod
UserDelegationDao userDelegationDao(Ref ref) {
  keepAliveWhenAuthenticated(ref);
  return UserDelegationDao(db: ref.watch(userProfileDatabaseProvider));
}

@DriftAccessor(tables: [UserDelegationTable])
class UserDelegationDao extends DatabaseAccessor<UserProfileDatabase>
    with _$UserDelegationDaoMixin {
  UserDelegationDao({required UserProfileDatabase db}) : super(db);

  Future<void> insertAll(List<UserDelegationEntity> usersDelegation) async {
    final databaseModels = await Future.wait<EventMessageDelegationDbModel>(
      usersDelegation.map((userDelegation) => userDelegation.toEventMessageDbModel()),
    );

    return batch((batch) {
      batch.insertAll(db.userDelegationTable, databaseModels, mode: InsertMode.insertOrReplace);
    });
  }

  Future<UserDelegationEntity?> get(String masterPubkey) async {
    final query = select(db.userDelegationTable)
      ..where((user) => user.masterPubkey.equals(masterPubkey))
      ..limit(1);

    final model = await query.getSingleOrNull();

    return model == null ? null : UserDelegationEntityExtension.fromEventMessageDbModel(model);
  }

  Stream<UserDelegationEntity?> watch(String masterPubkey) {
    final query = select(db.userDelegationTable)
      ..where((user) => user.masterPubkey.equals(masterPubkey))
      ..limit(1);

    return query.watchSingleOrNull().map(
          (model) =>
              model == null ? null : UserDelegationEntityExtension.fromEventMessageDbModel(model),
        );
  }

  Future<int> deleteDelegation(List<String> masterPubkeys) async {
    final query = delete(db.userDelegationTable)
      ..where((user) => user.masterPubkey.isIn(masterPubkeys));

    return query.go();
  }
}
