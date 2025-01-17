// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/create_article/providers/article_cover_processor_notifier.c.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

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

    final handleProcessorState = useCallback(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          processorState.whenOrNull(
            processed: (file) {
              selectedImage.value = file;
            },
          );
        });
      },
      [processorState],
    );

    useEffect(
      () {
        handleProcessorState();
        return null;
      },
      [handleProcessorState],
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
      requestDialog: const PermissionRequestSheet(
        permission: Permission.photos,
      ),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) {
        return GestureDetector(
          onTap: selectedImage.value == null ? onPressed : null,
          child: ScreenSideOffset.small(
            child: AspectRatio(
              aspectRatio: ArticleConstants.headerImageAspectRation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0.s),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(
                      Assets.svg.articlePlaceholder,
                      fit: BoxFit.cover,
                    ),
                    if (selectedImage.value != null)
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              File(selectedImage.value!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 12.0.s,
                            right: 12.0.s,
                            child: IconButton(
                              onPressed: () {
                                selectedImage.value = null;
                              },
                              icon: Assets.svg.iconFieldClearall.icon(size: 20.0.s),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36.0.s,
                            height: 36.0.s,
                            decoration: BoxDecoration(
                              color: context.theme.appColors.primaryAccent,
                              borderRadius: BorderRadius.circular(18.0.s),
                            ),
                            alignment: Alignment.center,
                            child: Assets.svg.iconLoginCamera.icon(size: 24.0.s),
                          ),
                          SizedBox(height: 7.0.s),
                          Text(
                            context.i18n.create_article_add_cover,
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
