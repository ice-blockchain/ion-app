import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

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
  })  : borderRadius = borderRadius ?? defaultBorderRadius,
        contentPadding = contentPadding ?? defaultContentPadding,
        leadingPadding = leadingPadding ?? defaultLeadingPadding,
        trailingPadding = trailingPadding ?? defaultTrailingPadding,
        constraints = constraints ?? defaultConstraints;

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
    Widget? leading,
    Widget? trailing,
    BoxBorder? border,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    BoxConstraints? constraints,
    Color? backgroundColor,
    VoidCallback? onTap,
    String? profilePicture,
    required Widget title,
    required Widget subtitle,
    bool verifiedBadge,
    bool iceBadge,
    DateTime? timeago,
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

  static BorderRadius get defaultBorderRadius =>
      BorderRadius.all(Radius.circular(16.0.s));
  static EdgeInsets get defaultContentPadding => EdgeInsets.all(12.0.s);
  static EdgeInsets get defaultLeadingPadding => EdgeInsets.only(right: 10.0.s);
  static EdgeInsets get defaultTrailingPadding => EdgeInsets.only(left: 10.0.s);
  static BoxConstraints get defaultConstraints =>
      BoxConstraints(minHeight: 60.0.s);

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
