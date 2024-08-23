import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountOption extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool isOptionEnabled;

  const SecureAccountOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isOptionEnabled,
  });

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
      trailing: isOptionEnabled
          ? Assets.images.icons.iconDappCheck.icon(
              color: context.theme.appColors.success,
            )
          : Assets.images.icons.iconArrowRight.icon(),
      onTap: onTap,
    );
  }
}
