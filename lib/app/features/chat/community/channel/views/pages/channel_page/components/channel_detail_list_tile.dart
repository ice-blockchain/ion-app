// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';

class ChannelDetailListTile extends ConsumerWidget {
  const ChannelDetailListTile({
    required this.title,
    required this.subtitle,
    super.key,
    this.trailing,
    this.onTap,
    this.borderColor,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? borderColor;
  static double get height => 58.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 12.0.s),
      backgroundColor: context.theme.appColors.secondaryBackground,
      border: Border.all(
        color: borderColor ?? context.theme.appColors.strokeElements,
      ),
      title: Text(
        title,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.terararyText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.theme.appTextThemes.body,
        overflow: TextOverflow.visible,
      ),
      trailing: trailing,
    );
  }
}
