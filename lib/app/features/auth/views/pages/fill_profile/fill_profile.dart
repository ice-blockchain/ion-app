// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.c.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/name_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/nickname_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/referral_input.dart';
import 'package:ion/app/features/auth/views/pages/fill_profile/components/fill_prifile_submit_button.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/features/user/hooks/use_verify_nickname_availability_error_message.dart';
import 'package:ion/app/features/user/hooks/use_verify_referral_exists_error_message.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_nickname_provider.c.dart';
import 'package:ion/app/features/user/providers/user_referral_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:ion/generated/assets.gen.dart';

class FillProfile extends HookConsumerWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final onboardingData = ref.watch(onboardingDataProvider);
    final isAvatarCompressing = ref.watch(
      imageProcessorNotifierProvider(ImageProcessingType.avatar)
          .select((state) => state is ImageProcessorStateCropped),
    );
    final initialName = onboardingData.displayName ?? '';
    final name = useState(initialName);
    final initialNickname = onboardingData.name ?? '';
    final nickname = useState(onboardingData.name ?? '');
    final initialReferral = onboardingData.referralName ?? '';
    final referral = useState(onboardingData.referralName ?? '');

    final isLoading = ref.watch(userNicknameNotifierProvider).isLoading ||
        ref.watch(userReferralNotifierProvider).isLoading;

    final onSubmit = useCallback(() async {
      if (formKey.currentState!.validate()) {
        await Future.wait(
          [
            ref
                .read(userNicknameNotifierProvider.notifier)
                .verifyNicknameAvailability(nickname: nickname.value),
            if (referral.value.isNotEmpty)
              ref
                  .read(userReferralNotifierProvider.notifier)
                  .verifyReferralExists(referral: referral.value),
          ],
        );
        if (ref.read(userNicknameNotifierProvider).hasError ||
            ref.read(userReferralNotifierProvider).hasError) {
          return;
        }

        final pickedAvatar = ref
            .read(imageProcessorNotifierProvider(ImageProcessingType.avatar))
            .whenOrNull(processed: (file) => file);
        if (pickedAvatar != null) {
          ref.read(onboardingDataProvider.notifier).avatar = pickedAvatar;
        }
        ref.read(onboardingDataProvider.notifier).name = nickname.value;
        ref.read(onboardingDataProvider.notifier).displayName = name.value;
        ref.read(onboardingDataProvider.notifier).referralName = referral.value;
        if (context.mounted) {
          await SelectLanguagesRoute().push<void>(context);
        }
      }
    });

    final verifyNicknameErrorMessage = useVerifyNicknameAvailabilityErrorMessage(ref);
    final verifyReferralErrorMessage = useVerifyReferralExistsErrorMessage(ref);

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
                          onChanged: (newValue) {
                            nickname.value = newValue;
                            verifyNicknameErrorMessage.value = null;
                          },
                          errorText: verifyNicknameErrorMessage.value,
                        ),
                        SizedBox(height: 16.0.s),
                        ReferralInput(
                          isLive: true,
                          initialValue: initialReferral,
                          textInputAction: TextInputAction.done,
                          onChanged: (newValue) {
                            referral.value = newValue;
                            verifyReferralErrorMessage.value = null;
                          },
                          errorText: verifyReferralErrorMessage.value,
                        ),
                        SizedBox(height: 26.0.s),
                        FillProfileSubmitButton(
                          disabled: name.value.isEmpty || nickname.value.isEmpty || isLoading,
                          loading: isAvatarCompressing || isLoading,
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
