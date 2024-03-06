import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
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

double defaultSocialIconButtonSide = 44.0.s;

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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = context.theme.iconButtonTheme.style?.iconSize
            ?.resolve(<MaterialState>{}) ??
        defaultSocialIconButtonSide;
    final double spaceBetweenButtons = (screenWidth -
            2 * ScreenSideOffset.defaultLargeMargin -
            4 * buttonWidth) /
        3;

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
