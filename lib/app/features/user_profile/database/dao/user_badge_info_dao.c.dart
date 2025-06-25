// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user/model/badges/badge_award.c.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.c.dart';
import 'package:ion/app/features/user_profile/database/tables/user_badge_info_table.c.dart';
import 'package:ion/app/features/user_profile/database/user_profile_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_badge_info_dao.c.g.dart';

@riverpod
UserBadgeInfoDao userBadgeInfoDao(Ref ref) {
  keepAliveWhenAuthenticated(ref);
  return UserBadgeInfoDao(db: ref.watch(userProfileDatabaseProvider));
}

@DriftAccessor(tables: [UserBadgeInfoTable])
class UserBadgeInfoDao extends DatabaseAccessor<UserProfileDatabase> with _$UserBadgeInfoDaoMixin {
  UserBadgeInfoDao({required UserProfileDatabase db}) : super(db);

  Future<void> insertAllProfileBadges(List<ProfileBadgesEntity> profileBadges) async {
    final databaseModels = await Future.wait<EventMessageBadgeDbModel>(
      profileBadges.map((userBadge) => userBadge.toEventMessageDbModel()),
    );

    return batch((batch) {
      batch.insertAll(db.userBadgeInfoTable, databaseModels, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> insertAllBadgeAwards(List<BadgeAwardEntity> badgeAwards) async {
    final databaseModels = await Future.wait<EventMessageBadgeDbModel>(
      badgeAwards.map((userBadge) => userBadge.toEventMessageDbModel()),
    );

    return batch((batch) {
      batch.insertAll(db.userBadgeInfoTable, databaseModels, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> insertAllBadgeDefinitions(List<BadgeDefinitionEntity> badgeDefinitions) async {
    final databaseModels = await Future.wait<EventMessageBadgeDbModel>(
      badgeDefinitions.map((userBadge) => userBadge.toEventMessageDbModel()),
    );

    return batch((batch) {
      batch.insertAll(db.userBadgeInfoTable, databaseModels, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> deleteProfileBadges(List<String> masterPubkeys) async {
    final query = delete(db.userDelegationTable)
      ..where((user) => user.masterPubkey.isIn(masterPubkeys));

    return query.go();
  }
}
