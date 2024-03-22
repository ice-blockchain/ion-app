import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_row.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/feed_filter.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_categories_dropdown.dart';

class FeedFilters extends HookWidget {
  const FeedFilters();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<FeedFilter> selectedFilter =
        useState(FeedFilter.forYou);

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ScreenSideOffset.small(
          child: SeparatedRow(
            separator: SizedBox(width: 12.0.s),
            children: <Widget>[
              const FeedCategoriesDropdown(),
              ...FeedFilter.values.map(
                (FeedFilter filter) => Button.menu(
                  onPressed: () {
                    selectedFilter.value = filter;
                  },
                  label: Text(
                    filter.getLabel(context),
                    style: selectedFilter.value == filter
                        ? TextStyle(
                            color: context.theme.appColors.primaryAccent,
                          )
                        : null,
                  ),
                  active: selectedFilter.value == filter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
