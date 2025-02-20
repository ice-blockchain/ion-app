// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_category_type.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CategorySelectModal extends HookConsumerWidget {
  const CategorySelectModal({
    required this.selectedCategory,
    super.key,
  });

  final String? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final searchValue = useState('');
    final filteredCategories = useMemoized(
      () {
        final query = searchValue.value.toLowerCase();
        return UserCategoryType.values.where((category) {
          final title = category.getTitle(context).toLowerCase();
          return title.contains(query);
        }).toList();
      },
      [searchValue.value],
    );

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              showBackButton: false,
              actions: [
                NavigationCloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
              title: Text(context.i18n.dapps_section_title_categories),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.theme.appColors.onPrimaryAccent,
              child: Column(
                children: [
                  SizedBox(height: 16.0.s),
                  ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) {
                        searchValue.value = value;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final category = filteredCategories[index];
                return MenuItemButton(
                  onPressed: () {
                    Navigator.of(context).pop(category);
                  },
                  trailingIcon: selectedCategory == category
                      ? Assets.svg.iconBlockCheckboxOnblue.icon(
                          color: colors.success,
                        )
                      : Assets.svg.iconBlockCheckboxOff.icon(
                          color: colors.tertararyText,
                        ),
                  child: Text(
                    category.getTitle(context),
                    style: textStyles.body,
                  ),
                );
              },
              childCount: filteredCategories.length,
            ),
          ),
        ],
      ),
    );
  }
}
