// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

class AvatarPicker extends HookConsumerWidget {
  const AvatarPicker({
    super.key,
    this.avatarFile,
    this.avatarUrl,
    this.onAvatarPicked,
    this.avatarSize = const Size.square(720),
  });

  final MediaFile? avatarFile;

  final String? avatarUrl;

  final void Function(MediaFile)? onAvatarPicked;

  final Size avatarSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localAvatarFile = useState<MediaFile?>(avatarFile);
    final loading = useState(false);

    Future<void> pickAvatar() async {
      final mediaService = ref.read(mediaServiceProvider);
      final compressService = ref.read(mediaCompressServiceProvider);

      try {
        final cameraImage = await mediaService.captureImageFromCamera();
        if (cameraImage == null || !context.mounted) return;
        final croppedImage = await mediaService.cropImage(context: context, path: cameraImage.path);
        if (croppedImage == null) return;
        localAvatarFile.value = croppedImage;
        loading.value = true;
        final compressedImage =
            await compressService.compressImage(croppedImage, size: avatarSize, quality: 70);
        onAvatarPicked?.call(compressedImage);
      } catch (error) {
        localAvatarFile.value = avatarFile;
        // TODO:show error to the user when imp
      } finally {
        if (context.mounted) {
          loading.value = false;
        }
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Avatar(
          size: 100.0.s,
          borderRadius: BorderRadius.circular(20.0.s),
          imageUrl: localAvatarFile.value == null ? avatarUrl : null,
          imageWidget: localAvatarFile.value != null
              ? Image.file(File(localAvatarFile.value!.path))
              : avatarUrl == null
                  ? Assets.svg.userPhotoArea.icon(size: 100.0.s)
                  : null,
        ),
        Positioned(
          bottom: -6.0.s,
          right: 0,
          child: GestureDetector(
            onTap: loading.value ? null : pickAvatar,
            child: Container(
              width: 36.0.s,
              height: 36.0.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.appColors.primaryAccent,
              ),
              child:
                  loading.value ? const IonLoadingIndicator() : Assets.svg.iconLoginCamera.icon(),
            ),
          ),
        ),
      ],
    );
  }
}
