// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ion/app/router/app_routes.c.dart';

class PlusButtonWithPermission extends StatelessWidget {
  const PlusButtonWithPermission({super.key});

  @override
  Widget build(BuildContext context) {
    final plusSize = 24.0.s;
    final iconPosition = plusSize - 8.0.s;

    return Positioned(
      bottom: iconPosition,
      child: PermissionAwareWidget(
        permissionType: Permission.camera,
        onGrantedPredicate: () =>
            GoRouter.of(context).state?.fullPath?.startsWith(FeedRoute().location) ?? false,
        onGranted: () => StoryRecordRoute().push<void>(context),
        requestDialog: const PermissionRequestSheet(permission: Permission.camera),
        settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
        builder: (context, onPressed) {
          return GestureDetector(
            onTap: onPressed,
            child: PlusIcon(size: plusSize),
          );
        },
      ),
    );
  }
}
