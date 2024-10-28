// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/fill_profile_notifier.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/name_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/nickname_input.dart';
import 'package:ion/app/features/auth/views/pages/fill_profile/components/fill_prifile_submit_button.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/features/user/providers/avatar_picker_notifier.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class FillProfile extends HookConsumerWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fillProfileState = ref.watch(fillProfileNotifierProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final onboardingData = ref.watch(onboardingDataProvider);
    final isAvatarCompressing =
        ref.watch(avatarPickerNotifierProvider.select((state) => state is AvatarPickerStatePicked));
    final nameController = useTextEditingController.fromValue(
      TextEditingValue(text: onboardingData.displayName ?? ''),
    );
    final nicknameController = useTextEditingController.fromValue(
      TextEditingValue(text: onboardingData.name ?? ''),
    );

    final onSubmit = useCallback(() async {
      if (formKey.currentState!.validate()) {
        await ref
            .read(fillProfileNotifierProvider.notifier)
            .submit(nickname: nicknameController.text, displayName: nameController.text);
        if (context.mounted) {
          await SelectLanguagesRoute().push<void>(context);
        }
      }
    });

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
                        AvatarPicker(
                          avatarUrl: onboardingData.avatarMediaAttachment?.url,
                        ),
                        SizedBox(height: 28.0.s),
                        NameInput(controller: nameController),
                        SizedBox(height: 16.0.s),
                        NicknameInput(
                          controller: nicknameController,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 26.0.s),
                        FillProfileSubmitButton(
                          disabled: isAvatarCompressing,
                          loading: fillProfileState.isLoading,
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
