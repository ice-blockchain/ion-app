import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/utility/image_picker_and_cropper/image_picker_and_cropper.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/text_field_wrapper/text_field_wrapper.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:image_cropper/image_cropper.dart';

class FillProfile extends HookConsumerWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultEdgeInset),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 65,
            ),
            Image.asset(
              Assets.images.iceRound.path,
            ),
            const SizedBox(
              height: 19,
            ),
            Text(
              'Your profile',
              style: context.theme.appTextThemes.headline1,
            ),
            Text(
              'Customize your account',
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWrapper(
              defaultIcon: Icons.person,
              onTextChanged: (String text) {},
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Button(
                trailingIcon: ImageIcon(
                  AssetImage(Assets.images.profilePaste.path),
                  size: 16,
                ),
                onPressed: () async {
                  final CroppedFile? croppedFile =
                      await ImagePickerAndCropper.pickImageFromGallery();
                  // CroppedFile? croppedFile = await ImagePickerAndCropper.takePhoto();
                  if (croppedFile != null) {
                    // Use the cropped image file
                  }
                },
                label: const Text('Save'),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
