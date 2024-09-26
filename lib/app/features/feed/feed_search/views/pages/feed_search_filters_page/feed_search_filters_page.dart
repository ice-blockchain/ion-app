import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_filter.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchFiltersPage extends ConsumerWidget {
  const FeedSearchFiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.feed_search_filter_title),
            actions: [
              NavigationTextButton(
                label: context.i18n.button_reset,
                onPressed: () {},
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.i18n.feed_search_filter_people,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
                SizedBox(height: 10.0.s),
                ...FeedSearchFilter.values.map((filter) {
                  return ListItem(
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
                      child: filter
                          .getIcon(context)
                          .icon(color: context.theme.appColors.primaryAccent),
                    ),
                    trailing: Assets.svg.iconDappCheck.icon(color: context.theme.appColors.success),
                    title: Text(filter.getLabel(context)),
                    backgroundColor: context.theme.appColors.secondaryBackground,
                    contentPadding: EdgeInsets.zero,
                    constraints: BoxConstraints(minHeight: 48.0.s),
                  );
                }),
                SizedBox(height: 18.0.s),
                Text(
                  context.i18n.feed_search_filter_languages,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
                SizedBox(height: 16.0.s),
                ListItem(),
                SizedBox(height: 34.0.s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0.s),
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(context.i18n.button_apply),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(height: 16.0.s),
                ScreenBottomOffset(margin: 16.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
