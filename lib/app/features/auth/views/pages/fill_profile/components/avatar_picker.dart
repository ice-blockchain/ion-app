import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/utils/image.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:image_cropper/image_cropper.dart';

class AvatarPicker extends HookWidget {
  const AvatarPicker({super.key, this.onAvatarPicked});

  final void Function(String)? onAvatarPicked;

  @override
  Widget build(BuildContext context) {
    final avatar = useState<CroppedFile?>(null);

    Future<void> pickAvatar() async {
      final croppedFile = await takePhoto();
      if (croppedFile != null) {
        avatar.value = croppedFile;
        onAvatarPicked?.call(croppedFile.path);
      }
    }

    return Stack(
      children: [
        if (avatar.value != null)
          CircleAvatar(
            radius: 50.0.s,
            backgroundImage: FileImage(File(avatar.value!.path)),
          )
        else
          Assets.images.icons.userPhotoArea.icon(size: 100.0.s),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickAvatar,
            child: Assets.images.icons.iconProfileCamera.icon(size: 36.0.s),
          ),
        ),
      ],
    );
  }
}
