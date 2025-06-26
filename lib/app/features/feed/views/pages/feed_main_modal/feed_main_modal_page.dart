// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_page.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/main_modal_item.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/banuba_service.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';

class FeedMainModalPage extends ConsumerWidget {
  const FeedMainModalPage({super.key});

  static const List<FeedType> feedTypeValues = FeedType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      topPadding: 0.0.s,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.feed_modal_title),
            showBackButton: false,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const HorizontalSeparator(),
            itemCount: feedTypeValues.length,
            itemBuilder: (BuildContext context, int index) {
              final type = feedTypeValues[index];

              if (type == FeedType.story) {
                return PermissionAwareWidget(
                  permissionType: Permission.camera,
                  requestId: 'story_record',
                  builder: (_, onPressed) => MainModalItem(
                    item: type,
                    onTap: onPressed,
                    index: index,
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
                    Future<void> showMediaPickerAndCreatePost() async {
                      final result = await showSimpleBottomSheet<List<MediaFile>>(
                        context: context,
                        child: const MediaPickerPage(
                          maxSelection: 1,
                          isBottomSheet: true,
                          type: MediaPickerType.video,
                        ),
                      );

                      if (result != null && result.isNotEmpty && context.mounted) {
                        final editedMedia = await ref.read(editMediaProvider(result[0]).future);
                        if (!context.mounted) return;
                        final editingResult = await CreateVideoRoute(
                              videoPath: editedMedia.path,
                              videoThumbPath: editedMedia.thumb,
                              mimeType: result[0].mimeType ?? '',
                            ).push<bool>(context) ??
                            false;

                        if (editingResult && context.mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              context.pop();
                            }
                          });
                        }
                      }
                    }

                    await showMediaPickerAndCreatePost();
                  },
                  requestDialog: const PermissionRequestSheet(permission: Permission.photos),
                  settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
                  builder: (_, onPressed) => MainModalItem(
                    item: type,
                    onTap: onPressed,
                    index: index,
                  ),
                );
              }

              return MainModalItem(
                item: type,
                onTap: () {
                  final createFlowRouteLocation = _getCreateFlowRouteLocation(type);
                  context.go(createFlowRouteLocation);
                },
                index: index,
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
      FeedType.article => CreateArticleRoute().location,
      _ => throw UnimplementedError(),
    };
  }
}
