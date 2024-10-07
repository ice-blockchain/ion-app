// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/components/visibility_settings_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class VisibilitySettingsModal extends StatelessWidget {
  const VisibilitySettingsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.visibility_settings_title_video),
        ),
        SizedBox(height: 12.0.s),
        const HorizontalSeparator(),
        const VisibilitySettingsList(),
        const HorizontalSeparator(),
        ScreenBottomOffset(
          margin: 0,
        ),
      ],
    );
  }
}
