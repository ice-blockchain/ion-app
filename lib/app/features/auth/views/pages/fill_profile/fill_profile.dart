import 'dart:io';

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

class CroppedFileNotifier extends StateNotifier<CroppedFile?> {
  CroppedFileNotifier() : super(null);

  set croppedFile(CroppedFile? value) {
    state = value;
  }
}

final StateNotifierProvider<CroppedFileNotifier, CroppedFile?>
    croppedFileProvider =
    StateNotifierProvider<CroppedFileNotifier, CroppedFile?>(
  (StateNotifierProviderRef<CroppedFileNotifier, CroppedFile?> ref) =>
      CroppedFileNotifier(),
);

class FillProfile extends HookConsumerWidget {
  FillProfile({super.key});

  final GlobalKey<TextFieldWrapperState> nameFieldKey =
      GlobalKey<TextFieldWrapperState>();
  final GlobalKey<TextFieldWrapperState> nicknameFieldKey =
      GlobalKey<TextFieldWrapperState>();
  final GlobalKey<TextFieldWrapperState> inviterFieldKey =
      GlobalKey<TextFieldWrapperState>();

  void onSave() {
    nameFieldKey.currentState!.validateText();
    nicknameFieldKey.currentState!.validateText();
    inviterFieldKey.currentState!.validateText();
    // final CroppedFile? croppedFile = ref.read(croppedFileProvider);
  }

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
    Future<void> addPhoto() async {
      final CroppedFile? croppedFile = await ImagePickerAndCropper.takePhoto();
      if (croppedFile != null) {
        ref.read(croppedFileProvider.notifier).croppedFile = croppedFile;
      }
    }

    final Widget profileImage = ref.watch(croppedFileProvider) != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.file(
              File(ref.watch(croppedFileProvider)!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.profilePhotoPlaceholder.path),
                fit: BoxFit.cover,
              ),
            ),
          );

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
            Stack(
              children: <Widget>[
                profileImage,
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: addPhoto,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(),
                      child: Image.asset(
                        Assets.images.profileCamera.path,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 28,
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
