// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
        onTap: onPressed,
        child: Container(
          width: 180.0.s,
          height: 100.0.s,
          color: context.theme.appColors.tertararyBackground,
          alignment: Alignment.center,
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
                          Assets.svg.iconArticleAddcover.icon(size: 24.0.s),
                          SizedBox(height: 6.0.s),
                          Text(
                            context.i18n.create_article_add_cover,
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.primaryAccent,
                            ),
                          ),
                        ],
                      );
                    }
                    return Image(
                      image: AssetEntityImageProvider(
                        asset,
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize.square(300),
                      ),
                      fit: BoxFit.cover,
                    );
                  },
                  orElse: SizedBox.shrink,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
