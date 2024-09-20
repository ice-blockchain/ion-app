import 'package:flutter/material.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/components/visibility_settings_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class VisibilitySettingsModal extends StatelessWidget {
  const VisibilitySettingsModal({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(title),
          ),
          SizedBox(height: 12.0.s),
          HorizontalSeparator(),
          VisibilitySettingsList(),
        ],
      ),
    );
  }
}
