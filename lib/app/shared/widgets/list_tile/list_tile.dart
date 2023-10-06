import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/list_tile/widgets/list_tile_subtitle.dart';
import 'package:ice/app/shared/widgets/list_tile/widgets/list_tile_title.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.contentPadding = const EdgeInsets.all(12),
    this.leadingPadding = const EdgeInsets.only(right: 10),
    this.trailingPadding = const EdgeInsets.only(left: 10),
    this.backgroundColor,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry trailingPadding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.appColors.tertararyBackground,
        border: border,
        borderRadius: borderRadius,
      ),
      padding: contentPadding,
      child: Row(
        children: <Widget>[
          if (leading != null) Padding(padding: leadingPadding, child: leading),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null) ListTileTitle(label: title!),
                if (subtitle != null) ListTileSubtitle(label: subtitle!),
              ],
            ),
          ),
          if (trailing != null)
            Padding(padding: trailingPadding, child: trailing),
        ],
      ),
    );
  }
}
