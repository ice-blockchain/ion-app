import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/features/feed/providers/selected_visibility_option_provider.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';

import 'visibility_settings_list_item.dart';

class VisibilitySettingsList extends ConsumerWidget {
  const VisibilitySettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedVisibilityOptionNotifierProvider);

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      itemCount: VisibilitySettingsOptions.values.length,
      separatorBuilder: (BuildContext context, int index) {
        return const HorizontalSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        final option = VisibilitySettingsOptions.values[index];
        final isSelected = selectedOption == option;

        return VisibilitySettingsListItem(
          option: option,
          isSelected: isSelected,
        );
      },
    );
  }
}
