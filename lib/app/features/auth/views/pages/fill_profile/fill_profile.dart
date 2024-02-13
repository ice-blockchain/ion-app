import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/inviter_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/name_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/nickname_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/validators.dart';
import 'package:ice/app/shared/utility/image_picker_and_cropper/image_picker_and_cropper.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/inputs/text_fields.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
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

class FillProfile extends IceSimplePage {
  const FillProfile(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
    final GlobalKey<TextFieldWrapperState> nameFieldKey =
        GlobalKey<TextFieldWrapperState>();
    final GlobalKey<TextFieldWrapperState> nicknameFieldKey =
        GlobalKey<TextFieldWrapperState>();
    final GlobalKey<TextFieldWrapperState> inviterFieldKey =
        GlobalKey<TextFieldWrapperState>();

    final NameController nameController = NameController();
    final NicknameController nicknameController = NicknameController();
    final InviterController inviterController = InviterController();

    Future<void> addPhoto() async {
      final CroppedFile? croppedFile = await ImagePickerAndCropper.takePhoto();
      if (croppedFile != null) {
        ref.read(croppedFileProvider.notifier).croppedFile = croppedFile;
      }
    }

    void onSave() {
      nameFieldKey.currentState!.validateText();
      nicknameFieldKey.currentState!.validateText();
      inviterFieldKey.currentState!.validateText();
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
              InputField(
                // autofocus: true,
                leadingIcon:
                    ImageIcon(AssetImage(Assets.images.fieldName.path)),
                label: 'Name',
                controller: nameController.controller,
                validator: (String? value) => validateName(value!),
                showLeadingSeparator: true,
                // key: nameFieldKey,
              ),
              InputField(
                leadingIcon:
                    ImageIcon(AssetImage(Assets.images.fieldNickname.path)),
                label: 'Nickname',
                controller: nicknameController.controller,
                validator: (String? value) => validateNickname(value!),
                showLeadingSeparator: true,
                // key: nicknameFieldKey,
                // textInputAction: TextInputAction.next,
              ),
              InputField(
                leadingIcon:
                    ImageIcon(AssetImage(Assets.images.fieldInviter.path)),
                label: 'Who invited you',
                controller: inviterController.controller,
                validator: (String? value) => validateWhoInvited(value!),
                showLeadingSeparator: true,
                // key: inviterFieldKey,
                // textInputAction: TextInputAction.done
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
      ),
    );
  }
}
