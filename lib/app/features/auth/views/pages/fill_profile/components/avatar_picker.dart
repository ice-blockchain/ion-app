import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/services/media/media.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:image_cropper/image_cropper.dart';

class AvatarPicker extends HookWidget {
  const AvatarPicker({super.key, this.onAvatarPicked});

  final void Function(String)? onAvatarPicked;

  @override
  Widget build(BuildContext context) {
    final avatar = useState<CroppedFile?>(null);

    Future<void> pickAvatar() async {
      final cameraImage = await MediaService.captureImageFromCamera();
      if (cameraImage == null || !context.mounted) return;
      final croppedImage = await MediaService.cropImage(context: context, path: cameraImage.path);
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
