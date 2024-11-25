// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum ChannelAdminType {
  owner,
  admin,
  moderator,
  ;

  String getTitle(BuildContext context) {
    return switch (this) {
      ChannelAdminType.owner => context.i18n.channel_create_admin_type_owner,
      ChannelAdminType.admin => context.i18n.channel_create_admin_type_admin,
      ChannelAdminType.moderator => context.i18n.channel_create_admin_type_moderator,
    };
  }

  String get iconAsset {
    return switch (this) {
      ChannelAdminType.owner => Assets.svg.iconChannelOwner,
      ChannelAdminType.admin => Assets.svg.iconChannelAdmin,
      ChannelAdminType.moderator => Assets.svg.iconChannelModerator,
    };
  }
}
