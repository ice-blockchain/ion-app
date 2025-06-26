// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/model/badges/badge_award.f.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.f.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.f.dart';

/// Data container for the current user's verified badge info.
class VerifiedBadgeEntities {
  const VerifiedBadgeEntities({
    required this.profileEntity,
    required this.awardEntity,
    required this.definitionEntity,
  });

  final ProfileBadgesEntity? profileEntity;
  final BadgeAwardEntity? awardEntity;
  final BadgeDefinitionEntity? definitionEntity;
}
