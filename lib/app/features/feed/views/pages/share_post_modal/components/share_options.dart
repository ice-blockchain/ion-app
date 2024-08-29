import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/separated/separated_row.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareOptions extends StatelessWidget {
  const ShareOptions({super.key});

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
              icon: Assets.images.icons.iconFeedStories.icon(),
              label: context.i18n.feed_add_story,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.images.icons.iconBlockCopy1.icon(color: Colors.black),
              label: context.i18n.feed_copy_link,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.images.icons.iconBookmarks.icon(color: Colors.black),
              label: context.i18n.feed_bookmark,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.images.icons.iconFeedWhatsapp.icon(),
              label: context.i18n.feed_whatsapp,
              onPressed: () {},
            ),
            _ShareOptionsMenuItem(
              buttonType: ButtonType.dropdown,
              icon: Assets.images.icons.iconFeedMore.icon(),
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
          ),
        ],
      ),
    );
  }
}
