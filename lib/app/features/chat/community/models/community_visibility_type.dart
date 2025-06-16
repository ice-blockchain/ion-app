// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/chat/model/selectable_type.dart';
import 'package:ion/generated/assets.gen.dart';

enum CommunityVisibilityType implements SelectableType {
  public,
  private;

  @override
  String getTitle(BuildContext context) {
    return switch (this) {
      CommunityVisibilityType.public => context.i18n.common_public,
      CommunityVisibilityType.private => context.i18n.common_private,
    };
  }

  @override
  String getDescription(BuildContext context) {
    return switch (this) {
      CommunityVisibilityType.public => context.i18n.channel_create_type_public_desc,
      CommunityVisibilityType.private => context.i18n.channel_create_type_private_desc,
    };
  }

  @override
  String get iconAsset {
    return switch (this) {
      CommunityVisibilityType.public => Assets.svgIconChannelType,
      CommunityVisibilityType.private => Assets.svgIconChannelPrivatetype,
    };
  }
}
