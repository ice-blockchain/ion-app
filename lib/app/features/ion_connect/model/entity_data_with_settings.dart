// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.c.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.c.dart';

mixin EntityDataWithSettings {
  List<EventSetting>? get settings;

  WhoCanReplySettingsOption get whoCanReplySetting {
    final whoCanReplySetting =
        settings?.firstWhereOrNull((setting) => setting is WhoCanReplyEventSetting)
            as WhoCanReplyEventSetting?;
    return whoCanReplySetting?.values.firstOrNull ?? const WhoCanReplySettingsOption.everyone();
  }

  bool get hasVerifiedUsersOnlyCanReplySettingOption {
    final whoSetting = settings?.firstWhereOrNull((setting) => setting is WhoCanReplyEventSetting)
        as WhoCanReplyEventSetting?;
    if (whoSetting == null) return false;
    // Check if any option is a verified badge restriction
    return whoSetting.values.any(
      (option) => option.when(
        everyone: () => false,
        followedAccounts: () => false,
        mentionedAccounts: () => false,
        accountsWithBadge: (badgeRef) =>
            badgeRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag &&
            badgeRef.kind == BadgeDefinitionEntity.kind,
      ),
    );
  }

  static List<EventSetting>? build({required WhoCanReplySettingsOption whoCanReply}) {
    return whoCanReply != const WhoCanReplySettingsOption.everyone()
        ? [
            WhoCanReplyEventSetting(values: {whoCanReply}),
          ]
        : null;
  }
}
