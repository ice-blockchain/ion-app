// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareOptions extends StatelessWidget {
  const ShareOptions({super.key});

  static double get iconSize => 28.0.s;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(top: 20.0.s, right: 16.0.s, left: 16.0.s),
        child: SeparatedRow(
          separator: SizedBox(width: 12.0.s),
          children: [
            _ShareOptionsMenuItem(
              buttonType: ButtonType.primary,
              icon: Assets.svg.iconFeedStories.icon(size: iconSize),
              label: context.i18n.feed_add_story,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconBlockCopy1.icon(size: iconSize, color: Colors.black),
              label: context.i18n.feed_copy_link,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconBookmarks.icon(size: iconSize, color: Colors.black),
              label: context.i18n.button_bookmark,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedWhatsapp.icon(size: iconSize),
              label: context.i18n.feed_whatsapp,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.svg.iconFeedMore.icon(size: iconSize),
              label: context.i18n.feed_more,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareOptionsMenuItem extends StatelessWidget {
  const _ShareOptionsMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.buttonType,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0.s,
      child: Column(
        children: [
          Button.icon(
            type: buttonType,
            onPressed: onPressed,
            icon: icon,
          ),
          SizedBox(height: 6.0.s),
          Text(
            label,
            style: context.theme.appTextThemes.caption2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
