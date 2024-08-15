import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class BackupOption extends StatelessWidget {
  const BackupOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.subtitle,
    this.isOptionEnabled = false,
    this.trailing,
  });

  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final String subtitle;
  final bool isOptionEnabled;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(title),
      backgroundColor: context.theme.appColors.tertararyBackground,
      subtitle: Text(
        subtitle,
        maxLines: 2,
      ),
      leading: icon,
      trailing: isOptionEnabled
          ? Assets.images.icons.iconDappCheck.icon(
              color: context.theme.appColors.success,
            )
          : null,
      onTap: onTap,
    );
  }
}
