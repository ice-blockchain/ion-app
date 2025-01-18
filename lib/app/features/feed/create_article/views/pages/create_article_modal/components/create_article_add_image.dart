// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/create_article/providers/article_cover_processor_notifier.c.dart';
import 'package:ion/app/features/feed/create_article/views/components/article_image_container.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class CreateArticleAddImage extends HookConsumerWidget {
  const CreateArticleAddImage({
    required this.selectedImage,
    super.key,
  });

  final ValueNotifier<MediaFile?> selectedImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaService = ref.watch(mediaServiceProvider);
    final processorState = ref.watch(articleCoverProcessorNotifierProvider);

    useOnInit(
      () => processorState.whenOrNull(
        processed: (file) {
          selectedImage.value = file;
          return null;
        },
      ),
      [processorState],
    );

    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () async {
        if (context.mounted) {
          final mediaFiles = await MediaPickerRoute(
            maxSelection: 1,
            mediaPickerType: MediaPickerType.image,
          ).push<List<MediaFile>>(context);

          if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
            final cropUiSettings = mediaService.buildCropImageUiSettings(
              context,
              aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            );

            await ref.read(articleCoverProcessorNotifierProvider.notifier).process(
                  assetId: mediaFiles.first.path,
                  cropUiSettings: cropUiSettings,
                );
          }
        }
      },
      requestDialog: const PermissionRequestSheet(permission: Permission.photos),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) => ArticleImageContainer(
        selectedImage: selectedImage.value,
        onPressed: onPressed,
        onClearImage: () => selectedImage.value = null,
      ),
    );
  }
}
