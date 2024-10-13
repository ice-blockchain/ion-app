// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/language_list_item.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/hooks/use_languages.dart';
import 'package:ice/app/hooks/use_selected_state.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SelectLanguages extends HookConsumerWidget {
  const SelectLanguages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (selectedLanguages, toggleLanguageSelection) =
        useSelectedState(ref.watch(onboardingDataProvider)?.languages ?? <String>[]);
    final searchQuery = useState('');
    final languages = useLanguages(query: searchQuery.value);

    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    final mayContinue = selectedLanguages.isNotEmpty;

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(),
          AuthHeader(
            title: context.i18n.common_select_languages,
            description: context.i18n.select_languages_description,
          ),
          SizedBox(height: 8.0.s),
          Expanded(
            child: CustomScrollView(
              slivers: [
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
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 12.0.s,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final language = languages[index];
                    return LanguageListItem(
                      language: language,
                      isSelected: selectedLanguages.contains(language.isoCode),
                      onTap: () {
                        toggleLanguageSelection(language.isoCode);
                      },
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue) ...[
            const HorizontalSeparator(),
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Button(
                label: Text(context.i18n.button_continue),
                mainAxisSize: MainAxisSize.max,
                onPressed: () async {
                  ref.read(onboardingDataProvider.notifier).languages = selectedLanguages;
                  hideKeyboardAndCallOnce(
                    callback: () => DiscoverCreatorsRoute().push<void>(context),
                  );
                },
              ),
            ),
            ScreenBottomOffset(margin: 36.0.s),
          ],
        ],
      ),
    );
  }
}
