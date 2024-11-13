// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/language_selector_page.dart';

class AppLanguageModal extends HookConsumerWidget {
  const AppLanguageModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with localization implementation
    final selectedLanguage = useState<String?>(null);

    return LanguageSelectorPage(
      title: context.i18n.app_language_title,
      description: context.i18n.app_language_description,
      toggleLanguageSelection: (language) => selectedLanguage.value = language,
      selectedLanguages: selectedLanguage.value == null ? [] : [selectedLanguage.value!],
    );
  }
}
