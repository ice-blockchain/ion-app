// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/features/feed/data/models/visibility_settings_options.dart';
import 'package:ion/app/features/feed/views/pages/visibility_settings_modal/components/visibility_settings_list_item.dart';

class VisibilitySettingsList extends ConsumerWidget {
  const VisibilitySettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      itemCount: VisibilitySettingsOptions.values.length,
      separatorBuilder: (_, __) => const HorizontalSeparator(),
      itemBuilder: (BuildContext context, int index) {
        final option = VisibilitySettingsOptions.values[index];

        return VisibilitySettingsListItem(
          option: option,
        );
      },
    );
  }
}
