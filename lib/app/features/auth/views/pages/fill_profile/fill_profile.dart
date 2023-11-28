import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/text_field_wrapper/text_field_wrapper.dart';
import 'package:ice/generated/assets.gen.dart';

class FillProfile extends HookConsumerWidget {
  FillProfile({super.key});

  final GlobalKey<TextFieldWrapperState> nameFieldKey =
      GlobalKey<TextFieldWrapperState>();
  final GlobalKey<TextFieldWrapperState> nicknameFieldKey =
      GlobalKey<TextFieldWrapperState>();
  final GlobalKey<TextFieldWrapperState> inviterFieldKey =
      GlobalKey<TextFieldWrapperState>();

  Future<void> onSave() async {
    nameFieldKey.currentState!.validateText();
    nicknameFieldKey.currentState!.validateText();
    inviterFieldKey.currentState!.validateText();
  }

  // final CroppedFile? croppedFile =
  //                   await ImagePickerAndCropper.pickImageFromGallery();
  //               // CroppedFile? croppedFile = await ImagePickerAndCropper.takePhoto();
  //               if (croppedFile != null) {
  //                 // Use the cropped image file
  //               }

  bool validateName(String text) {
    return text.trim().isNotEmpty;
  }

  bool validateNickname(String text) {
    return text.trim().isNotEmpty && text.contains('@') && text.length > 1;
  }

  bool validateWhoInvited(String text) {
    return text.trim().isNotEmpty;
  }

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
              defaultIcon: AssetImage(Assets.images.fieldName.path),
              onTextChanged: (String text) {},
              placeholder: 'Name',
              validator: validateName,
              key: nameFieldKey,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFieldWrapper(
              defaultIcon: AssetImage(Assets.images.fieldNickname.path),
              onTextChanged: (String text) {},
              placeholder: 'Nickname',
              validator: validateNickname,
              key: nicknameFieldKey,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFieldWrapper(
              defaultIcon: AssetImage(Assets.images.fieldInviter.path),
              onTextChanged: (String text) {},
              placeholder: 'Who invited you',
              validator: validateWhoInvited,
              key: inviterFieldKey,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Button(
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.profileSave.path),
                  size: 24,
                ),
                onPressed: onSave,
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
