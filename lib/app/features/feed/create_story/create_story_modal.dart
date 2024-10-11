// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CreateStoryModal extends StatelessWidget {
  const CreateStoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_story_nav_title),
          ),
          const Spacer(),
          Center(
            child: PermissionAwareWidget(
              permissionType: Permission.camera,
              builder: (context, onPressed) {
                return GestureDetector(
                  onTap: onPressed,
                  child: const Text(
                    'Create Story',
                  ),
                );
              },
              onGranted: () {
                StoryCameraRoute().push<void>(context);
              },
              requestDialog: PermissionRequestSheet.fromType(context, Permission.camera),
              settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
