import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_navigation/feed_navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedNavigation extends StatelessWidget {
  const FeedNavigation({
    required this.onFiltersPressed,
  });

  final VoidCallback onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        children: <Widget>[
          Expanded(
            child: SearchInput(
              onTextChanged: (String st) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: FeedNavigationButton(
              onPressed: () {},
              icon: Assets.images.icons.iconHomeNotification.icon(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: FeedNavigationButton(
              onPressed: onFiltersPressed,
              icon: Assets.images.icons.iconHeaderMenu.icon(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
