// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/generated/assets.gen.dart';

class ContactItemAvatar extends StatelessWidget {
  const ContactItemAvatar({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  static double get imageWidth => 60.0.s;

  static double get iceLogoSize => 24.0.s;

  static double get iceLogoBorderRadius => 6.0.s;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Avatar(
          size: imageWidth,
          imageUrl: contactData.icon,
          borderRadius: BorderRadius.circular(14.0.s),
        ),
        if (contactData.hasIceAccount == true)
          Positioned(
            right: -4.0.s,
            bottom: -4.0.s,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(iceLogoBorderRadius),
                border: Border.all(
                  color: context.theme.appColors.secondaryBackground,
                  width: 2.0.s,
                ),
              ),
              position: DecorationPosition.foreground,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iceLogoBorderRadius),
                child: Assets.svg.iconBadgeIcelogo.icon(
                  size: iceLogoSize,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
