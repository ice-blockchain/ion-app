// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/feed_search/model/feed_search_filter_people.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedSearchFilterPeopleSection extends StatelessWidget {
  const FeedSearchFilterPeopleSection({
    required this.selectedFilter,
    required this.onFilterChange,
    super.key,
  });

  final FeedSearchFilterPeople selectedFilter;

  final void Function(FeedSearchFilterPeople) onFilterChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.i18n.feed_search_filter_people,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        SizedBox(height: 10.0.s),
        ...FeedSearchFilterPeople.values.map((filter) {
          return ListItem(
            onTap: () {
              onFilterChange(filter);
            },
            leading: Container(
              width: 36.0.s,
              height: 36.0.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.appColors.onSecondaryBackground,
                borderRadius: BorderRadius.all(Radius.circular(10.0.s)),
                border: Border.all(
                  width: 1.0.s,
                  color: context.theme.appColors.onTerararyFill,
                ),
              ),
              child: filter.getIcon(context).icon(color: context.theme.appColors.primaryAccent),
            ),
            trailing: selectedFilter == filter
                ? Assets.svg.iconDappCheck.icon(color: context.theme.appColors.success)
                : null,
            title: Text(filter.getLabel(context)),
            backgroundColor: context.theme.appColors.secondaryBackground,
            contentPadding: EdgeInsets.zero,
            constraints: BoxConstraints(minHeight: 48.0.s),
          );
        }),
      ],
    );
  }
}
