// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/components/feed_modal_item.dart';
import 'package:ice/app/features/wallet/model/feed_type.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class FeedMainModalPage extends StatelessWidget {
  const FeedMainModalPage({super.key});

  static const List<FeedType> feedTypeValues = FeedType.values;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.screen(
            title: Text(context.i18n.feed_modal_title),
            showBackButton: false,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const HorizontalSeparator(),
            itemCount: feedTypeValues.length,
            itemBuilder: (BuildContext context, int index) {
              final type = feedTypeValues[index];

              if (type == FeedType.story) {
                return PermissionAwareWidget(
                  permissionType: Permission.camera,
                  builder: (_, onPressed) => FeedModalItem(
                    feedType: type,
                    onTap: onPressed,
                  ),
                  onGranted: () => StoryCameraRoute().push<void>(context),
                  requestDialog: PermissionRequestSheet.fromType(context, Permission.camera),
                  settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
                );
              }

              return FeedModalItem(
                feedType: type,
                onTap: () {
                  final createFlowRouteLocation = _getCreateFlowRouteLocation(type);
                  context
                    ..go(GoRouterState.of(context).currentTab.baseRouteLocation)
                    ..go(createFlowRouteLocation);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCreateFlowRouteLocation(FeedType type) {
    return switch (type) {
      FeedType.post => CreatePostRoute().location,
      FeedType.video => CreateVideoRoute().location,
      FeedType.article => CreateArticleRoute().location,
      _ => throw UnimplementedError(),
    };
  }
}
