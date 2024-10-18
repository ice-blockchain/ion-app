// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

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
              onTap: () => FeedSimpleSearchRoute().push<void>(context),
              child: const IgnorePointer(child: SearchInput()),
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
            child: const FeedFiltersMenuButton(),
          ),
        ],
      ),
    );
  }
}
