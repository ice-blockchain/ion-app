import 'package:flutter/material.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/components/explore_button.dart';
import 'package:ice/generated/assets.gen.dart';

class InitialExploreControlsState extends StatelessWidget {
  const InitialExploreControlsState({
    required this.onFiltersPressed,
  });

  final VoidCallback onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SearchInput(
            onTextChanged: (String st) {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0.s),
          child: ExploreButton(
            onPressed: () {},
            iconPath: Assets.images.icons.iconHomeNotification.path,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0.s),
          child: ExploreButton(
            onPressed: onFiltersPressed,
            iconPath: Assets.images.icons.iconHeaderMenu.path,
          ),
        ),
      ],
    );
  }
}
