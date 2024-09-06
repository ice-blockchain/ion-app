import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_button.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_button/navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedNavigation extends StatelessWidget {
  const FeedNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FeedSearchRoute().push<void>(context),
              child: IgnorePointer(child: SearchInput()),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: NavigationButton(
              onPressed: () => {},
              icon: Assets.svg.iconHomeNotification.icon(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: FeedFiltersMenuButton(),
          ),
        ],
      ),
    );
  }
}
