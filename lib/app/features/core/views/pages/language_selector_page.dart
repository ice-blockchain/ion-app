// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/pages/select_languages/language_list_item.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/hooks/use_languages.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class LanguageSelectorPage extends HookConsumerWidget {
  const LanguageSelectorPage({
    required this.title,
    required this.description,
    required this.selectedLanguages,
    required this.toggleLanguageSelection,
    this.appBar,
    this.continueButton,
    this.preferredLanguages,
    super.key,
  });

  final String title;
  final String description;
  final Widget? appBar;
  final Widget? continueButton;
  final List<String> selectedLanguages;
  final List<Language>? preferredLanguages;
  final void Function(String) toggleLanguageSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');
    final localePreferredLanguages = ref.watch(localePreferredContentLanguagesProvider);
    final preferredLangs = preferredLanguages ?? localePreferredLanguages;
    final languages = useLanguages(query: searchQuery.value, preferredLangs: preferredLangs);

    final mayContinue = selectedLanguages.isNotEmpty;

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: appBar ?? NavigationAppBar.modal(),
          ),
          SliverToBoxAdapter(
            child: AuthHeader(
              title: title,
              description: description,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 26.0.s),
          ),
          CollapsingAppBar(
            topOffset: 8.0.s,
            height: SearchInput.height,
            child: ScreenSideOffset.small(
              child: SearchInput(
                onTextChanged: (String value) => searchQuery.value = value,
              ),
            ),
          ),
          SliverList.separated(
            itemCount: languages.length,
            separatorBuilder: (BuildContext _, int __) => SizedBox(height: 12.0.s),
            itemBuilder: (BuildContext context, int index) {
              final language = languages[index];
              return LanguageListItem(
                language: language,
                isSelected: selectedLanguages.contains(language.isoCode),
                onTap: () => toggleLanguageSelection(language.isoCode),
              );
            },
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.only(
              bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
            ),
          ),
          if (mayContinue && continueButton != null) ...[
            const SliverToBoxAdapter(child: HorizontalSeparator()),
            SliverToBoxAdapter(child: SizedBox(height: 16.0.s)),
            SliverToBoxAdapter(
              child: ScreenSideOffset.small(child: continueButton!),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 8.0.s + MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ],
      ),
    );
  }
}
