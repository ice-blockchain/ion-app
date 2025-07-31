// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class BackupOption extends StatelessWidget {
  const BackupOption({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.subtitle,
    super.key,
    this.isOptionEnabled = false,
    this.trailing,
    this.isLoading = false,
  });

  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final String subtitle;
  final bool isOptionEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final trailingIcon = isOptionEnabled
        ? Assets.svg.iconDappCheck.icon(
            color: context.theme.appColors.success,
          )
        : null;

    return ListItem(
      title: Text(title),
      backgroundColor: context.theme.appColors.tertiaryBackground,
      subtitle: Text(
        subtitle,
        maxLines: 2,
      ),
      leading: icon,
      trailing: isLoading ? const IONLoadingIndicatorThemed() : trailingIcon,
      onTap: onTap,
    );
  }
}
