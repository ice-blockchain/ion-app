// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/data/models/badges/badge_award.c.dart';
import 'package:ion/app/features/user/data/models/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/data/models/badges/profile_badges.c.dart';

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
