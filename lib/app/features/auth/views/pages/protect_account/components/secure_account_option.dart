import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountOption extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const SecureAccountOption({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(title),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: Button.icon(
        backgroundColor: context.theme.appColors.secondaryBackground,
        borderColor: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0.s),
        ),
        type: ButtonType.menuInactive,
        size: 36.0.s,
        onPressed: () {},
        icon: icon,
      ),
      trailing: trailing ?? Assets.images.icons.iconArrowRight.icon(),
      onTap: onTap,
    );
  }
}
