// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareActionButtons extends StatelessWidget {
  const ShareActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0.s,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 44.0.s),
        children: [
          _ShareButton(
            icon: Assets.svg.iconBlockCopy1.icon(),
            label: 'Copy link',
          ),
          _ShareButton(
            icon: Assets.svg.iconFeedWhatsapp.icon(),
            label: 'WhatsApp',
          ),
          _ShareButton(
            icon: Assets.svg.iconFeedTelegram.icon(),
            label: 'Telegram',
          ),
          _ShareButton(
            icon: Assets.svg.iconLoginXlogo.icon(),
            label: 'X',
          ),
          _ShareButton(
            icon: Assets.svg.iconFeedMore.icon(),
            label: 'More',
          ),
        ].map((button) {
          return Padding(
            padding: EdgeInsets.only(right: 25.0.s),
            child: button,
          );
        }).toList(),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.0.s,
          height: 56.0.s,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0.s),
            border: Border.all(
              color: context.theme.appColors.onTerararyFill,
            ),
            color: context.theme.appColors.tertararyBackground,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16.0.s),
              child: Padding(
                padding: EdgeInsets.all(14.0.s),
                child: icon,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0.s),
        Text(
          label,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
