// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/components/who_can_reply_settings_list.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class WhoCanViewSettingsModal extends StatelessWidget {
  const WhoCanViewSettingsModal({
    this.title,
    super.key,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(title ?? context.i18n.visibility_settings_title_video),
        ),
        SizedBox(height: 12.0.s),
        const HorizontalSeparator(),
        const WhoCanReplySettingsList(),
        const HorizontalSeparator(),
        ScreenBottomOffset(
          margin: 0,
        ),
      ],
    );
  }
}
