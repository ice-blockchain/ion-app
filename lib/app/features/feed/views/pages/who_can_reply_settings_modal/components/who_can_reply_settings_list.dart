// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/components/who_can_reply_settings_list_item.dart';

class WhoCanReplySettingsList extends ConsumerWidget {
  const WhoCanReplySettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      itemCount: WhoCanReplySettingsOption.values.length,
      separatorBuilder: (_, __) => const HorizontalSeparator(),
      itemBuilder: (BuildContext context, int index) {
        final option = WhoCanReplySettingsOption.values[index];

        return WhoCanReplySettingsListItem(option: option);
      },
    );
  }
}
