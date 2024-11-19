// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/wallet/model/feed_type.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/main_modal_item.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

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
                  builder: (_, onPressed) => MainModalItem(
                    item: type,
                    onTap: onPressed,
                  ),
                  onGranted: () => StoryRecordRoute().push<void>(context),
                  requestDialog: const PermissionRequestSheet(
                    permission: Permission.camera,
                  ),
                  settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
                );
              } else if (type == FeedType.video) {
                return PermissionAwareWidget(
                  permissionType: Permission.photos,
                  onGranted: () async {
                    if (context.mounted) {
                      // final mediaFiles = await MediaPickerRoute().push<List<MediaFile>>(context);
                      //implement onMediaSelected(mediaFiles);
                    }
                  },
                  requestDialog: PermissionRequestSheet.fromType(context, Permission.photos),
                  settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
                  builder: (context, onPressed) {
                    return ActionsToolbarButton(
                      icon: Assets.svg.iconGalleryOpen,
                      onPressed: onPressed,
                    );
                  },
                );
              }

              return MainModalItem(
                item: type,
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
