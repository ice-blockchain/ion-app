import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/utils/image.dart';
import 'package:ice/generated/assets.gen.dart';

part './variants/list_item_checkbox.dart';
part './variants/list_item_user.dart';

class ListItem extends StatelessWidget {
  ListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.border,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    BoxConstraints? constraints,
    this.backgroundColor,
    this.onTap,
  })  : borderRadius =
            borderRadius ?? BorderRadius.all(Radius.circular(16.0.s)),
        contentPadding = contentPadding ?? EdgeInsets.all(12.0.s),
        leadingPadding = leadingPadding ?? EdgeInsets.only(right: 10.0.s),
        trailingPadding = trailingPadding ?? EdgeInsets.only(left: 10.0.s),
        constraints = constraints ?? BoxConstraints(minHeight: 60.0.s);

  factory ListItem.checkbox({
    Key? key,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    BoxBorder? border,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    BoxConstraints? constraints,
    Color? backgroundColor,
    required VoidCallback onTap,
    required bool value,
  }) = _ListItemWithCheckbox;

  factory ListItem.user({
    Key? key,
    Widget? trailing,
    BoxBorder? border,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    BoxConstraints? constraints,
    Color? backgroundColor,
    VoidCallback? onTap,
    required String name,
    required String nickname,
    required String profilePicture,
    bool verifiedBadge,
    bool iceBadge,
  }) = _ListItemUser;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry trailingPadding;
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildMainContainer(
      context: context,
      child: Container(
        constraints: constraints,
        padding: contentPadding,
        child: Row(
          children: <Widget>[
            if (leading != null)
              Padding(padding: leadingPadding, child: leading),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (title != null)
                    DefaultTextStyle(
                      style: _getDefaultTitleStyle(context),
                      child: title!,
                    ),
                  if (subtitle != null)
                    DefaultTextStyle(
                      style: _getDefaultSubtitleStyle(context),
                      child: subtitle!,
                    ),
                ],
              ),
            ),
            if (trailing != null)
              Padding(padding: trailingPadding, child: trailing),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer({
    required Widget child,
    required BuildContext context,
  }) {
    final Color backgroundColor = _getBackgroundColor(context);
    return onTap != null
        ? Material(
            color: backgroundColor,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
              child: child,
            ),
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: borderRadius,
            ),
            child: child,
          );
  }

  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ?? context.theme.appColors.tertararyBackground;
  }

  TextStyle _getDefaultTitleStyle(BuildContext context) {
    return context.theme.appTextThemes.body
        .copyWith(color: context.theme.appColors.primaryText);
  }

  TextStyle _getDefaultSubtitleStyle(BuildContext context) {
    return context.theme.appTextThemes.caption3
        .copyWith(color: context.theme.appColors.secondaryText);
  }
}
