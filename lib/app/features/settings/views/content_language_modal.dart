// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/views/pages/language_selector_page.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ContentLanguageModal extends HookConsumerWidget {
  const ContentLanguageModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace this code when logic will be implemented
    final (selectedLanguages, toggleLanguageSelection) = useSelectedState(
      ref.watch(onboardingDataProvider).languages ??
          [ref.watch(localePreferredLanguageProvider).isoCode],
    );

    return LanguageSelectorPage(
      title: context.i18n.content_language_title,
      description: context.i18n.content_language_description,
      toggleLanguageSelection: toggleLanguageSelection,
      selectedLanguages: selectedLanguages,
      appBar: NavigationAppBar.modal(
        actions: const [NavigationCloseButton()],
      ),
    );
  }
}
