// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.f.dart';
import 'package:ion/generated/assets.gen.dart';

class Subcategories extends StatelessWidget {
  const Subcategories({
    required this.subcategories,
    required this.onSubcategorySelected,
    required this.selectedSubcategories,
    super.key,
  });

  final Map<String, FeedInterestsSubcategory> subcategories;
  final void Function(String) onSubcategorySelected;
  final Set<String> selectedSubcategories;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return Column(
      children: subcategories.entries.map(
        (subcategoryEntry) {
          final isSelected = selectedSubcategories.contains(subcategoryEntry.key);
          return ListItem(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 6.0.s),
            constraints: const BoxConstraints(),
            onTap: () => onSubcategorySelected(subcategoryEntry.key),
            backgroundColor: colors.secondaryBackground,
            trailing: isSelected
                ? Assets.svg.iconBlockCheckboxOnblue.icon(color: colors.success)
                : Assets.svg.iconBlockCheckboxOff.icon(color: colors.tertararyText),
            title: Text(subcategoryEntry.value.display, style: textStyles.body),
          );
        },
      ).toList(),
    );
  }
}
