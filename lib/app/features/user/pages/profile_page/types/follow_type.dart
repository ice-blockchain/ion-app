// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum FollowType {
  followers,
  following;

  String get iconAsset {
    return switch (this) {
      FollowType.followers => Assets.svg.iconSearchFollowers,
      FollowType.following => Assets.svg.iconSearchFollow,
    };
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case FollowType.followers:
        return context.i18n.profile_followers;
      case FollowType.following:
        return context.i18n.profile_following;
    }
  }
}
