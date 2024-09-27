import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class AvatarPicker extends HookConsumerWidget {
  const AvatarPicker({super.key, this.onAvatarPicked});

  final void Function(String)? onAvatarPicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaService = ref.watch(mediaServiceProvider);
    final avatar = useState<MediaFile?>(null);

    Future<void> pickAvatar() async {
      final cameraImage = await mediaService.captureImageFromCamera();
      if (cameraImage == null || !context.mounted) return;
      final croppedImage = await mediaService.cropImage(context: context, path: cameraImage.path);
      if (croppedImage == null) return;
      avatar.value = croppedImage;
      onAvatarPicked?.call(croppedImage.path);
    }

    return Stack(
      children: [
        if (avatar.value != null)
          CircleAvatar(
            radius: 50.0.s,
            backgroundImage: FileImage(File(avatar.value!.path)),
          )
        else
          Assets.svg.userPhotoArea.icon(size: 100.0.s),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickAvatar,
            child: Assets.svg.iconProfileCamera.icon(size: 36.0.s),
          ),
        ),
      ],
    );
  }
}
