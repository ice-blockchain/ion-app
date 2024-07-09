import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/components/avatar_picker.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/keyboard/keyboard.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class FillProfile extends IcePage {
  const FillProfile({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final nicknameController = useTextEditingController();
    final inviterController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final loading = useState(false);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  AuthHeader(
                    title: context.i18n.fill_profile_title,
                    description: context.i18n.fill_profile_description,
                    icon: Assets.images.logo.logoIce.icon(size: 65.0.s),
                  ),
                  ScreenSideOffset.large(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0.s,
                        ),
                        AvatarPicker(
                          onAvatarPicked: (String path) {},
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
                          controller: nameController,
                          validator: (String? value) {
                            if (Validators.isEmpty(value)) return '';
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          scrollPadding: EdgeInsets.all(120.0.s),
                        ),
                        SizedBox(
                          height: 16.0.s,
                        ),
                        TextInput(
                          prefixIcon: TextInputIcons(
                            hasRightDivider: true,
                            icons: <Widget>[
                              Assets.images.icons.iconFieldNickname.icon(),
                            ],
                          ),
                          labelText: context.i18n.fill_profile_input_nickname,
                          controller: nicknameController,
                          validator: (String? value) {
                            if (Validators.isEmpty(value)) return '';
                            if (Validators.isInvalidLength(
                              value,
                              minLength: 4,
                            )) {
                              return '';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          scrollPadding: EdgeInsets.all(120.0.s),
                        ),
                        SizedBox(
                          height: 16.0.s,
                        ),
                        TextInput(
                          prefixIcon: TextInputIcons(
                            hasRightDivider: true,
                            icons: <Widget>[
                              Assets.images.icons.iconFieldInviter.icon(),
                            ],
                          ),
                          labelText:
                              context.i18n.fill_profile_input_who_invited,
                          controller: inviterController,
                          validator: (String? value) {
                            if (Validators.isEmpty(value)) return '';
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          scrollPadding: EdgeInsets.all(120.0.s),
                        ),
                        SizedBox(
                          height: 26.0.s,
                        ),
                        Button(
                          disabled: loading.value,
                          trailingIcon: loading.value
                              ? const ButtonLoadingIndicator()
                              : Assets.images.icons.iconProfileSave.icon(
                                  color:
                                      context.theme.appColors.onPrimaryAccent,
                                ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              loading.value = true;
                              hideKeyboard(context);
                              await Future<void>.delayed(
                                const Duration(seconds: 1),
                              );
                              loading.value = false;
                              hideKeyboardAndCallOnce(
                                callback: () =>
                                    SelectLanguagesRoute().push<void>(context),
                              );
                            }
                          },
                          label: Text(context.i18n.button_save),
                          mainAxisSize: MainAxisSize.max,
                        ),
                        SizedBox(
                          height: 40.0.s + MediaQuery.paddingOf(context).bottom,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
