import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

enum SocialButtonType {
  apple,
  nostr,
  x,
  expand,
  fb,
  github,
  discord,
  linkedin;

  Widget get buttonIcon {
    return switch (this) {
      SocialButtonType.apple => Assets.images.icons.iconLoginApplelogo,
      SocialButtonType.nostr => Assets.images.icons.iconLoginNostrlogo,
      SocialButtonType.x => Assets.images.icons.iconLoginXlogo,
      SocialButtonType.fb => Assets.images.icons.iconLoginFacebook,
      SocialButtonType.github => Assets.images.icons.iconLoginGithub,
      SocialButtonType.discord => Assets.images.icons.iconLoginDiscord,
      SocialButtonType.linkedin => Assets.images.icons.iconLoginLinkedin,
      SocialButtonType.expand => Assets.images.icons.iconLoginDropup,
    }
        .icon();
  }
}

typedef SocialButtonCallback = void Function(SocialButtonType type);

class Socials extends StatefulWidget {
  const Socials({this.onSocialButtonPressed});

  final SocialButtonCallback? onSocialButtonPressed;

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

  static double get defaultButtonsOffset => 16.0.s;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonSide = (screenWidth -
            (2 * ScreenSideOffset.defaultLargeMargin) -
            (3 * defaultButtonsOffset)) /
        4;

    return Column(
      children: <Widget>[
        buildSocialRow(firstRowButtons, buttonSide),
        if (isSecondRowVisible) SizedBox(height: defaultButtonsOffset),
        if (isSecondRowVisible) buildSocialRow(secondRowButtons, buttonSide),
      ],
    );
  }

  Widget buildSocialRow(List<SocialButtonType> types, double buttonSide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types
          .map((SocialButtonType type) => buildSocialButton(type, buttonSide))
          .toList(),
    );
  }

  Widget buildSocialButton(SocialButtonType type, double buttonSide) {
    Widget socialIcon = type.buttonIcon;

    if (type == SocialButtonType.expand) {
      socialIcon = isSecondRowVisible
          ? Assets.images.icons.iconLoginDropup.icon()
          : Assets.images.icons.iconLoginDropdown.icon();
    }

    return Button.icon(
      type: ButtonType.outlined,
      icon: socialIcon,
      onPressed: () => handleButtonPress(type),
      size: buttonSide,
    );
  }

  void handleButtonPress(SocialButtonType type) {
    if (type == SocialButtonType.expand) {
      setState(() {
        isSecondRowVisible = !isSecondRowVisible;
      });
    } else {
      if (widget.onSocialButtonPressed != null) {
        widget.onSocialButtonPressed?.call(type);
      }
    }
  }
}
