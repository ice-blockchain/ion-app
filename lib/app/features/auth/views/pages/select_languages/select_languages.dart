// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.c.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/views/pages/language_selector_page.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

class SelectLanguages extends HookConsumerWidget {
  const SelectLanguages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishNotifier = ref.watch(onboardingCompleteNotifierProvider);
    ref.displayErrors(onboardingCompleteNotifierProvider);
    final preferredLanguages = ref.watch(localePreferredContentLanguagesProvider);

    final (selectedLanguages, toggleLanguageSelection) = useSelectedState(
      ref.watch(onboardingDataProvider).languages ?? [preferredLanguages.first.isoCode],
    );

    final userIdentity = ref.watch(currentUserIdentityProvider).valueOrNull;

    return LanguageSelectorPage(
      title: context.i18n.common_select_languages,
      description: context.i18n.select_languages_description,
      toggleLanguageSelection: toggleLanguageSelection,
      selectedLanguages: selectedLanguages,
      preferredLanguages: preferredLanguages,
      continueButton: Button(
        disabled: finishNotifier.isLoading,
        trailingIcon: finishNotifier.isLoading ? const IONLoadingIndicator() : null,
        label: Text(context.i18n.button_continue),
        mainAxisSize: MainAxisSize.max,
        onPressed: () {
          ref.read(onboardingDataProvider.notifier).languages = selectedLanguages;
          if ((userIdentity?.ionConnectRelays).emptyOrValue.isNotEmpty) {
            // Skip "follow-creators" step, if user identity is already created,
            // because identity is created based on the selected creators
            // and we can't let user change them at this point.
            guardPasskeyDialog(
              context,
              (child) => RiverpodVerifyIdentityRequestBuilder(
                provider: onboardingCompleteNotifierProvider,
                requestWithVerifyIdentity: (
                  OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
                ) {
                  ref.read(onboardingCompleteNotifierProvider.notifier).finish(onVerifyIdentity);
                },
                child: child,
              ),
            );
          } else {
            DiscoverCreatorsRoute().push<void>(context);
          }
        },
      ),
    );
  }
}
