import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/generated/assets.gen.dart';

enum SocialButtonType { apple, nostr, x, expand, fb, github, discord, linkedin }

Map<SocialButtonType, String> socialIcons = <SocialButtonType, String>{
  SocialButtonType.apple: Assets.images.apple.path,
  SocialButtonType.nostr: Assets.images.nostr.path,
  SocialButtonType.x: Assets.images.x.path,
  SocialButtonType.fb: Assets.images.facebook.path,
  SocialButtonType.github: Assets.images.github.path,
  SocialButtonType.discord: Assets.images.discord.path,
  SocialButtonType.linkedin: Assets.images.linkedin.path,
};

class Socials extends StatefulWidget {
  @override
  _SocialsState createState() => _SocialsState();
}

class _SocialsState extends State<Socials> {
  bool isSecondRowVisible = false;

  final List<SocialButtonType> firstRowButtons = <SocialButtonType>[
    SocialButtonType.apple,
    SocialButtonType.nostr,
    SocialButtonType.x,
    SocialButtonType.expand,
  ];

  final List<SocialButtonType> secondRowButtons = <SocialButtonType>[
    SocialButtonType.fb,
    SocialButtonType.github,
    SocialButtonType.discord,
    SocialButtonType.linkedin,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = context.theme.iconButtonTheme.style?.iconSize
            ?.resolve(<MaterialState>{}) ??
        kDefaultIconButtonSide;
    final double spaceBetweenButtons =
        (screenWidth - 2 * kDefaultPadding - 4 * buttonWidth) / 3;

    return Column(
      children: <Widget>[
        buildSocialRow(firstRowButtons),
        if (isSecondRowVisible) SizedBox(height: spaceBetweenButtons),
        if (isSecondRowVisible) buildSocialRow(secondRowButtons),
      ],
    );
  }

  Widget buildSocialRow(List<SocialButtonType> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types
          .map((SocialButtonType type) => buildSocialButton(type))
          .toList(),
    );
  }

  Widget buildSocialButton(SocialButtonType type) {
    String? socialIcon = socialIcons[type];

    if (type == SocialButtonType.expand) {
      socialIcon = isSecondRowVisible
          ? Assets.images.loginDropup.path
          : Assets.images.loginDropdown.path;
    }

    return Button.icon(
      type: ButtonType.outlined,
      icon: Image.asset(socialIcon!),
      onPressed: () => handleButtonPress(type),
    );
  }

  void handleButtonPress(SocialButtonType type) {
    if (type == SocialButtonType.expand) {
      setState(() {
        isSecondRowVisible = !isSecondRowVisible;
      });
    } else {
      performSocialAction(type);
    }
  }

  void performSocialAction(SocialButtonType type) {}
}
