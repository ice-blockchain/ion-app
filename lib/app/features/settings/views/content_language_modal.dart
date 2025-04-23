// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/language_selector_page.dart';
import 'package:ion/app/features/settings/providers/optimistic_content_language_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ContentLanguageModal extends HookConsumerWidget {
  const ContentLanguageModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguages = ref.watch(
      contentLangSetProvider.select(
        (async) => async.valueOrNull?.hashtags ?? const <String>[],
      ),
    );

    return LanguageSelectorPage(
      title: context.i18n.content_language_title,
      description: context.i18n.content_language_description,
      toggleLanguageSelection: (String lang) {
        ref.read(contentLangSetNotifierProvider.notifier).toggle(lang);
      },
      selectedLanguages: selectedLanguages,
      appBar: NavigationAppBar.modal(
        actions: const [NavigationCloseButton()],
      ),
    );
  }
}
