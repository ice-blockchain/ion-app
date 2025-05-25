// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.c.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';

mixin EntityDataWithSettings {
  List<EventSetting>? get settings;

  WhoCanReplySettingsOption get whoCanReplySetting {
    final whoCanReplySetting =
        settings?.firstWhereOrNull((setting) => setting is WhoCanReplyEventSetting)
            as WhoCanReplyEventSetting?;
    return whoCanReplySetting?.values.firstOrNull ?? const WhoCanReplySettingsOption.everyone();
  }

  static List<EventSetting>? build({required WhoCanReplySettingsOption whoCanReply}) {
    return whoCanReply != const WhoCanReplySettingsOption.everyone()
        ? [
            WhoCanReplyEventSetting(values: {whoCanReply}),
          ]
        : null;
  }
}
