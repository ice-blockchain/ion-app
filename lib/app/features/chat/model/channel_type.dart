// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum ChannelType {
  public,
  private,
  ;

  String getTitle(BuildContext context) {
    return switch (this) {
      ChannelType.public => context.i18n.common_public,
      ChannelType.private => context.i18n.common_private,
    };
  }

  String getDesc(BuildContext context) {
    return switch (this) {
      ChannelType.public => context.i18n.channel_create_type_public_desc,
      ChannelType.private => context.i18n.channel_create_type_private_desc,
    };
  }

  String get iconAsset {
    return switch (this) {
      ChannelType.public => Assets.svg.iconChannelType,
      ChannelType.private => Assets.svg.iconChannelPrivatetype,
    };
  }
}
