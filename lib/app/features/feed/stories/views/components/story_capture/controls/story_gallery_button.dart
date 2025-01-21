// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/components.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/banuba_service.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class StoryGalleryButton extends HookConsumerWidget {
  const StoryGalleryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processorState = ref.watch(imageProcessorNotifierProvider(ImageProcessingType.story));

    final processedImage = useCallback(
      () async {
        final mediaFiles = await MediaPickerRoute(maxSelection: 1).push<List<MediaFile>>(context);
        if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
          await ref
              .read(imageProcessorNotifierProvider(ImageProcessingType.story).notifier)
              .process(
                assetId: mediaFiles.first.path,
                cropUiSettings: ref.read(mediaServiceProvider).buildCropImageUiSettings(
                  context,
                  aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
                ),
              );
        }
      },
      [],
    );

    useEffect(
      () {
        processorState.whenOrNull(
          processed: (file) async {
            final editedPath = await ref.read(banubaServiceProvider).editPhoto(file.path);

            if (editedPath == file.path) {
              await processedImage();
              return;
            }

            if (context.mounted) {
              final previewResult = await StoryPreviewRoute(
                path: editedPath,
                mimeType: file.mimeType,
              ).push<bool>(context);

              if (previewResult == false) {
                await processedImage();
              }
            }
          },
        );
        return null;
      },
      [processorState, processedImage],
    );

    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () async {
        final mediaFiles = await MediaPickerRoute(maxSelection: 1).push<List<MediaFile>>(context);
        if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
          await ref
              .read(imageProcessorNotifierProvider(ImageProcessingType.story).notifier)
              .process(
                assetId: mediaFiles.first.path,
                cropUiSettings: ref.read(mediaServiceProvider).buildCropImageUiSettings(
                  context,
                  aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
                ),
              );
        }
      },
      requestDialog: const PermissionRequestSheet(
        permission: Permission.photos,
      ),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) {
        return Consumer(
          builder: (context, ref, _) {
            final galleryPreview = ref.watch(latestGalleryPreviewProvider).valueOrNull;

            if (galleryPreview == null) {
              return StoryControlButton(
                onPressed: onPressed,
                icon: Assets.svg.iconGalleryOpen.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
              );
            }

            return StoryControlButton(
              iconPadding: 0.0.s,
              onPressed: onPressed,
              icon: Image(
                width: 36.0.s,
                height: 36.0.s,
                fit: BoxFit.cover,
                image: AssetEntityImageProvider(
                  galleryPreview,
                  isOriginal: false,
                  thumbnailSize: const ThumbnailSize.square(300),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
