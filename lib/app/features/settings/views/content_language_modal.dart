// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/language_selector_page.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ContentLanguageModal extends HookConsumerWidget {
  const ContentLanguageModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageInterestSet =
        ref.watch(currentUserInterestsSetProvider(InterestSetType.languages));
    final selectedLanguages = languageInterestSet.valueOrNull?.data.hashtags;

    return LanguageSelectorPage(
      title: context.i18n.content_language_title,
      description: context.i18n.content_language_description,
      toggleLanguageSelection: (String lang) {
        if (!languageInterestSet.isLoading && selectedLanguages != null) {
          final updatedLanguages = {...selectedLanguages};
          if (updatedLanguages.contains(lang)) {
            updatedLanguages.remove(lang);
          } else {
            updatedLanguages.add(lang);
          }
          if (updatedLanguages.isNotEmpty) {
            ref
                .read(currentUserInterestsSetProvider(InterestSetType.languages).notifier)
                .set(updatedLanguages.toList());
          }
        }
      },
      selectedLanguages: selectedLanguages ?? [],
      appBar: NavigationAppBar.modal(
        actions: const [NavigationCloseButton()],
      ),
    );
  }
}
