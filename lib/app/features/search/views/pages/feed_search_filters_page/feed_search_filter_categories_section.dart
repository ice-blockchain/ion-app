// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedSearchFilterCategoriesSection extends StatelessWidget {
  const FeedSearchFilterCategoriesSection({
    required this.selectedFilter,
    required this.onFilterChange,
    super.key,
  });

  final List<FeedCategory> selectedFilter;

  final void Function(List<FeedCategory>) onFilterChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.i18n.feed_search_filter_categories,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        SizedBox(height: 4.0.s),
        ...FeedCategory.values.map<Widget>((category) {
          return ListItem(
            onTap: () {
              onFilterChange([category]); //TODO
            },
            leading: ButtonIconFrame(
              color: category.getColor(context),
              icon: category.getIcon(context),
              containerSize: 36.0.s,
            ),
            trailing: selectedFilter.contains(category)
                ? Assets.svg.iconBlockCheckboxOn.icon(color: context.theme.appColors.success)
                : Assets.svg.iconblockRadiooff.icon(color: context.theme.appColors.tertararyText),
            title: Text(category.getLabel(context)),
            backgroundColor: context.theme.appColors.secondaryBackground,
            contentPadding: EdgeInsets.zero,
          );
        }).intersperse(const HorizontalSeparator()),
      ],
    );
  }
}
