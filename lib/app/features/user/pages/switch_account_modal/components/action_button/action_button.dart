import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: onTap,
      leading: Button.icon(
        backgroundColor: context.theme.appColors.onSecondaryBackground,
        borderColor: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0.s),
        ),
        size: 36.0.s,
        onPressed: onTap,
        icon: icon,
      ),
      title: Text(label, style: context.theme.appTextThemes.body),
      trailing: Assets.images.icons.iconArrowRight.icon(),
      backgroundColor: context.theme.appColors.tertararyBackground,
    );
  }
}
