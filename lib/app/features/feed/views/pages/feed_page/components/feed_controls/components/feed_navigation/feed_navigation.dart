import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_button/navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedNavigation extends StatelessWidget {
  const FeedNavigation({
    required this.onFiltersPressed,
    super.key,
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
            padding: EdgeInsets.only(left: UiSize.small),
            child: NavigationButton(
              onPressed: () {},
              icon: Assets.images.icons.iconHomeNotification.icon(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: UiSize.small),
            child: NavigationButton(
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
