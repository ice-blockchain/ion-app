// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum FollowType {
  followers,
  following;

  String get iconAsset {
    return switch (this) {
      FollowType.followers => Assets.svg.iconSearchFollow,
      FollowType.following => Assets.svg.iconSearchFollowers,
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

  String getTitleWithCounter(BuildContext context, int counter) {
    switch (this) {
      case FollowType.followers:
        return context.i18n.profile_followers_with_counter(counter);
      case FollowType.following:
        return context.i18n.profile_following_with_counter(counter);
    }
  }
}
