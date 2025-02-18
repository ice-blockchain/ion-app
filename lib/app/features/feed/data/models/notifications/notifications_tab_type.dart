// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum NotificationsTabType {
  all,
  comments,
  followers,
  likes,
  ;

  String get iconAsset {
    return switch (this) {
      NotificationsTabType.all => Assets.svg.iconTabAll,
      NotificationsTabType.comments => Assets.svg.iconBlockComment,
      NotificationsTabType.followers => Assets.svg.iconSearchFollow,
      NotificationsTabType.likes => Assets.svg.iconVideoLikeOff,
    };
  }

  String getTitle(BuildContext context) => switch (this) {
        NotificationsTabType.all => context.i18n.core_all,
        NotificationsTabType.comments => context.i18n.notifications_type_comments,
        NotificationsTabType.followers => context.i18n.notifications_type_followers,
        NotificationsTabType.likes => context.i18n.notifications_type_likes,
      };
}
