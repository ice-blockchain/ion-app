// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/router/model/main_modal_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

enum ConversationType implements MainModalListItem {
  private,
  group,
  channel;

  @override
  String getDisplayName(BuildContext context) {
    return switch (this) {
      ConversationType.private => context.i18n.chat_modal_private_title,
      ConversationType.group => context.i18n.chat_modal_group_title,
      ConversationType.channel => context.i18n.chat_modal_channel_title,
    };
  }

  @override
  String getDescription(BuildContext context) {
    return switch (this) {
      ConversationType.private => context.i18n.chat_modal_private_description,
      ConversationType.group => context.i18n.chat_modal_group_description,
      ConversationType.channel => context.i18n.chat_modal_channel_description,
    };
  }

  @override
  Color getIconColor(BuildContext context) {
    return switch (this) {
      ConversationType.private => context.theme.appColors.orangePeel,
      ConversationType.group => context.theme.appColors.raspberry,
      ConversationType.channel => context.theme.appColors.success,
    };
  }

  @override
  String get iconAsset {
    return switch (this) {
      ConversationType.private => Assets.svg.iconChatCreatenew,
      ConversationType.group => Assets.svg.iconSearchGroups,
      ConversationType.channel => Assets.svg.iconFeedArticles,
    };
  }
}
