import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/constants/languages.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/hooks/use_selected_state.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchLanguagesPage extends HookWidget {
  const FeedSearchLanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final (selectedLanguages, toggleLanguageSelection) = useSelectedState<Language>();
    final searchText = useState('');

    final filteredLanguages = searchText.value.isEmpty
        ? languages
        : languages
            .where((language) =>
                language.name.toLowerCase().contains(searchText.value.toLowerCase().trim()))
            .toList();

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.feed_search_select_languages_title),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) => searchText.value = value,
            ),
          ),
          SizedBox(height: 14.0.s),
          Expanded(
            child: ListView.builder(
                itemCount: filteredLanguages.length,
                itemBuilder: (BuildContext context, int index) {
                  final language = filteredLanguages[index];
                  final isSelected = selectedLanguages.contains(language);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      toggleLanguageSelection(language);
                    },
                    child: ScreenSideOffset.small(
                      child: SizedBox(
                        height: 44.0.s,
                        child: Row(
                          children: [
                            Text(language.flag, style: TextStyle(fontSize: 21.0.s)),
                            SizedBox(width: 16.0.s),
                            Expanded(
                              child: Text(
                                language.name,
                                style: context.theme.appTextThemes.subtitle2.copyWith(
                                  color: context.theme.appColors.primaryText,
                                ),
                              ),
                            ),
                            if (isSelected) Assets.svg.iconBlockCheckboxOnblue.icon(),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          if (selectedLanguages.isNotEmpty) ...[
            HorizontalSeparator(),
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Button(
                label: Text(context.i18n.button_continue),
                mainAxisSize: MainAxisSize.max,
                onPressed: () {
                  context.pop(selectedLanguages.toList());
                },
              ),
            )
          ],
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
