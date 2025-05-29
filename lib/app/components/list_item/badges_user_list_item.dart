// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/badges_notifier.c.dart';

class BadgesUserListItem extends HookConsumerWidget {
  const BadgesUserListItem({
    required this.pubkey,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.border,
    this.borderRadius,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.constraints,
    this.backgroundColor,
    this.onTap,
    this.iceBadge = false,
    this.isSelected = false,
    this.avatarSize,
    super.key,
  });

  final String pubkey;
  final Widget title;
  final Widget subtitle;
  final Widget? leading;
  final Widget? trailing;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool iceBadge;
  final bool isSelected;
  final double? avatarSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserVerified = ref.watch(isUserVerifiedProvider(pubkey)).valueOrNull.falseOrValue;
    final isNicknameProofed = ref.watch(isNicknameProofedProvider(pubkey)).valueOrNull ?? true;

    return ListItem.user(
      pubkey: pubkey,
      title: title,
      subtitle: isNicknameProofed
          ? subtitle
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                subtitle,
                SizedBox(width: 4.0.s),
                Text(context.i18n.nickname_not_owned_suffix),
              ],
            ),
      leading: leading,
      trailing: trailing,
      border: border,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      constraints: constraints,
      backgroundColor: backgroundColor,
      onTap: onTap,
      iceBadge: iceBadge,
      verifiedBadge: isUserVerified,
      isSelected: isSelected,
      avatarSize: avatarSize,
    );
  }
}
