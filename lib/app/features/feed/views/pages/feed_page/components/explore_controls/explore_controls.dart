import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class ExploreControls extends HookWidget {
  const ExploreControls({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 9.0.s),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SearchInput(
              onTextChanged: (String st) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: _ExploreButton(
              onPressed: () {},
              iconPath: Assets.images.icons.iconHomeNotification.path,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: _ExploreButton(
              onPressed: () {},
              iconPath: Assets.images.icons.iconHeaderMenu.path,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreButton extends StatelessWidget {
  const _ExploreButton({
    required this.iconPath,
    required this.onPressed,
  });

  final String iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      tintColor: context.theme.appColors.onTerararyFill,
      size: 40.0.s,
      onPressed: onPressed,
      icon: ButtonIcon(
        iconPath,
        color: context.theme.appColors.primaryText,
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
