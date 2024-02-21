import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

part './variants/list_item_checkbox.dart';

class ListItem extends StatelessWidget {
  ListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.border,
    this.backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? contentPadding,
    EdgeInsets? leadingPadding,
    EdgeInsets? trailingPadding,
    BoxConstraints? constraints,
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
    required GestureTapCallback onTap,
    required bool value,
  }) = _ListItemWithCheckbox;

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
  final GestureTapCallback? onTap;

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
    required BuildContext context,
    required Widget child,
  }) {
    final Widget container = Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: border,
        borderRadius: borderRadius,
      ),
      child: child,
    );
    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: container,
          )
        : container;
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
