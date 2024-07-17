import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
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
          CircleAvatar(
            radius: 50.0.s,
            backgroundImage: Assets.images.misc.authPhotoPlaceholder.provider(),
            backgroundColor: context.theme.appColors.secondaryBackground,
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickAvatar,
            child: CircleAvatar(
              radius: 18.0.s,
              backgroundImage: Assets.images.misc.iconCamera.provider(),
            ),
          ),
        ),
      ],
    );
  }
}
