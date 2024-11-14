// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class CreateArticleAddImage extends HookConsumerWidget {
  const CreateArticleAddImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = useState<MediaFile?>(null);

    return PermissionAwareWidget(
      permissionType: Permission.photos,
      onGranted: () async {
        if (context.mounted) {
          final mediaFiles = await MediaPickerRoute(maxSelection: 1).push<List<MediaFile>>(context);
          if (mediaFiles != null && mediaFiles.isNotEmpty) {
            selectedImage.value = mediaFiles.first;
          }
        }
      },
      requestDialog: PermissionRequestSheet.fromType(context, Permission.photos),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
      builder: (context, onPressed) => GestureDetector(
        onTap: selectedImage.value == null ? onPressed : null,
        child: ScreenSideOffset.small(
          child: AspectRatio(
            aspectRatio: 343 / 210,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.appColors.tertararyBackground,
                image: DecorationImage(
                  image: Assets.images.article.imagePlaceholder.image().image,
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0.s),
                child: Consumer(
                  builder: (context, ref, _) {
                    final assetEntityAsync =
                        ref.watch(assetEntityProvider(selectedImage.value?.path ?? ''));

                    return assetEntityAsync.maybeWhen(
                      data: (asset) {
                        if (asset == null) {
                          return Column(
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
                          );
                        }
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Image(
                                image: AssetEntityImageProvider(
                                  asset,
                                  isOriginal: false,
                                  thumbnailSize: const ThumbnailSize.square(300),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0.0.s,
                              right: 0.0.s,
                              child: IconButton(
                                onPressed: () {
                                  selectedImage.value = null;
                                },
                                icon: Assets.svg.iconFieldClearall.icon(size: 20.0.s),
                              ),
                            ),
                          ],
                        );
                      },
                      orElse: SizedBox.shrink,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
