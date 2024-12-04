// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/name_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/nickname_input.dart';
import 'package:ion/app/features/auth/views/pages/fill_profile/components/fill_prifile_submit_button.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class FillProfile extends HookConsumerWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final onboardingData = ref.watch(onboardingDataProvider);
    final isAvatarCompressing = ref.watch(
      avatarProcessorNotifierProvider.select((state) => state is AvatarProcessorStateCropped),
    );
    final initialName = onboardingData.displayName ?? '';
    final name = useState(initialName);
    final initialNickname = onboardingData.name ?? '';
    final nickname = useState(onboardingData.name ?? '');

    final onSubmit = useCallback(() async {
      if (formKey.currentState!.validate()) {
        final pickedAvatar =
            ref.read(avatarProcessorNotifierProvider).whenOrNull(processed: (file) => file);
        if (pickedAvatar != null) {
          ref.read(onboardingDataProvider.notifier).avatar = pickedAvatar;
        }
        ref.read(onboardingDataProvider.notifier).name = name.value;
        ref.read(onboardingDataProvider.notifier).displayName = nickname.value;
        await SelectLanguagesRoute().push<void>(context);
      }
    });

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          title: context.i18n.fill_profile_title,
          description: context.i18n.fill_profile_description,
          icon: Assets.svg.iconLoginIcelogo.icon(size: 44.0.s),
          mainAxisAlignment: MainAxisAlignment.start,
          onBackPress: () async {
            await ref.read(authProvider.notifier).signOut();
            if (context.mounted) {
              GetStartedRoute().go(context);
            }
          },
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  ScreenSideOffset.large(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0.s),
                        AvatarPicker(
                          avatarWidget: onboardingData.avatar != null
                              ? Image.file(File(onboardingData.avatar!.path))
                              : null,
                        ),
                        SizedBox(height: 28.0.s),
                        NameInput(
                          isLive: true,
                          initialValue: initialName,
                          onChanged: (newValue) => name.value = newValue,
                        ),
                        SizedBox(height: 16.0.s),
                        NicknameInput(
                          isLive: true,
                          initialValue: initialNickname,
                          textInputAction: TextInputAction.done,
                          onChanged: (newValue) => nickname.value = newValue,
                        ),
                        SizedBox(height: 26.0.s),
                        FillProfileSubmitButton(
                          disabled: name.value.isEmpty || nickname.value.isEmpty,
                          loading: isAvatarCompressing,
                          onPressed: onSubmit,
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
