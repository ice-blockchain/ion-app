import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/text_field_wrapper/text_field_wrapper.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/inviter_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/name_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/controllers/nickname_controller.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/validators.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/utils/image.dart';
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
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
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
      final CroppedFile? croppedFile = await takePhoto();
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
            borderRadius: BorderRadius.circular(50.0.s),
            child: Image.file(
              File(ref.watch(croppedFileProvider)!.path),
              width: 100.0.s,
              height: 100.0.s,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: 100.0.s,
            height: 100.0.s,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.misc.authPhotoPlaceholder.provider(),
                fit: BoxFit.cover,
              ),
            ),
          );

    return SheetContent(
      body: SingleChildScrollView(
        child: ScreenSideOffset.large(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 65.0.s,
              ),
              Image.asset(
                Assets.images.logo.logoIce.path,
              ),
              SizedBox(
                height: 19.0.s,
              ),
              Text(
                context.i18n.fill_profile_title,
                style: context.theme.appTextThemes.headline1,
              ),
              Text(
                context.i18n.fill_profile_description,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
              SizedBox(
                height: 20.0.s,
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
                        width: 36.0.s,
                        height: 36.0.s,
                        decoration: const BoxDecoration(),
                        child: Image.asset(
                          Assets.images.misc.iconCamera.path,
                          width: 36.0.s,
                          height: 36.0.s,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.0.s,
              ),
              TextInput(
                prefixIcon: TextInputIcons(
                  hasRightDivider: true,
                  icons: <Widget>[
                    Assets.images.icons.iconFieldName.icon(),
                  ],
                ),
                labelText: context.i18n.fill_profile_input_name,
                controller: nameController.controller,
                validator: (String? value) => validateName(value!),
                textInputAction: TextInputAction.next,
              ),
              TextInput(
                prefixIcon: TextInputIcons(
                  hasRightDivider: true,
                  icons: <Widget>[
                    Assets.images.icons.iconFieldNickname.icon(),
                  ],
                ),
                labelText: context.i18n.fill_profile_input_nickname,
                controller: nicknameController.controller,
                validator: (String? value) => validateNickname(value!),
                textInputAction: TextInputAction.next,
              ),
              TextInput(
                prefixIcon: TextInputIcons(
                  hasRightDivider: true,
                  icons: <Widget>[
                    Assets.images.icons.iconFieldInviter.icon(),
                  ],
                ),
                labelText: context.i18n.fill_profile_input_who_invited,
                controller: inviterController.controller,
                validator: (String? value) => validateWhoInvited(value!),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 20.0.s,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0.s, bottom: 74.0.s),
                child: Center(
                  child: Button(
                    leadingIcon: Assets.images.icons.iconProfileSave.icon(),
                    onPressed: onSave,
                    label: Text(context.i18n.button_save),
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
