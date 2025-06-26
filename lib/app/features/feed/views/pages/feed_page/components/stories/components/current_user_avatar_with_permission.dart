// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_item_content.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class CurrentUserAvatarWithPermission extends StatelessWidget {
  const CurrentUserAvatarWithPermission({
    required this.pubkey,
    required this.hasStories,
    required this.gradient,
    required this.isViewed,
    required this.imageUrl,
    super.key,
  });

  final String pubkey;
  final bool hasStories;
  final Gradient? gradient;
  final bool isViewed;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return PermissionAwareWidget(
      permissionType: Permission.camera,
      requestId: 'story_record',
      onGrantedPredicate: () =>
          GoRouter.of(context).state.fullPath?.startsWith(FeedRoute().location) ?? false,
      onGranted: () => hasStories
          ? StoryViewerRoute(pubkey: pubkey).push<void>(context)
          : StoryRecordRoute().push<void>(context),
      requestDialog: const PermissionRequestSheet(permission: Permission.camera),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
      builder: (context, onPressed) {
        return GestureDetector(
          onTap: onPressed,
          child: StoryItemContent(
            pubkey: pubkey,
            name: context.i18n.common_you,
            gradient: gradient,
            isViewed: isViewed,
            onTap: onPressed,
          ),
        );
      },
    );
  }
}
