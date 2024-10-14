// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/components/avatar_picker.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/components/fill_prifile_submit_button.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/components/name_input.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/components/nickname_input.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class FillProfile extends HookConsumerWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController.fromValue(
      TextEditingValue(text: ref.watch(onboardingDataProvider)?.displayName ?? ''),
    );
    final nicknameController = useTextEditingController.fromValue(
      TextEditingValue(text: ref.watch(onboardingDataProvider)?.name ?? ''),
    );
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          title: context.i18n.fill_profile_title,
          description: context.i18n.fill_profile_description,
          icon: Assets.svg.iconLoginIcelogo.icon(size: 44.0.s),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  ScreenSideOffset.large(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0.s),
                        AvatarPicker(onAvatarPicked: (String path) {}),
                        SizedBox(height: 28.0.s),
                        NameInput(controller: nameController),
                        SizedBox(height: 16.0.s),
                        NicknameInput(controller: nicknameController),
                        SizedBox(height: 26.0.s),
                        FillProfileSubmitButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              ref.read(onboardingDataProvider.notifier).name =
                                  nicknameController.text;
                              ref.read(onboardingDataProvider.notifier).displayName =
                                  nameController.text;
                              hideKeyboardAndCallOnce(
                                callback: () => SelectLanguagesRoute().push<void>(context),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 40.0.s + MediaQuery.paddingOf(context).bottom),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
