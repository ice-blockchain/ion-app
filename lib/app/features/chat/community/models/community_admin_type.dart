// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum CommunityAdminType {
  owner,
  admin,
  moderator;

  String getTitle(BuildContext context) {
    return switch (this) {
      CommunityAdminType.owner => context.i18n.channel_create_admin_type_owner,
      CommunityAdminType.admin => context.i18n.channel_create_admin_type_admin,
      CommunityAdminType.moderator => context.i18n.channel_create_admin_type_moderator,
    };
  }

  String get iconAsset {
    return switch (this) {
      CommunityAdminType.owner => Assets.svgIconChannelOwner,
      CommunityAdminType.admin => Assets.svgIconChannelAdmin,
      CommunityAdminType.moderator => Assets.svgIconChannelModerator,
    };
  }
}
