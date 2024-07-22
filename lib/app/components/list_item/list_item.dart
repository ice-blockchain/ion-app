import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

part './variants/list_item_checkbox.dart';
part './variants/list_item_text_with_icon.dart';
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
    bool? switchTitleStyles,
    this.secondary,
    this.isSelected,
    this.backgroundColor,
    this.onTap,
  })  : borderRadius = borderRadius ?? defaultBorderRadius,
        contentPadding = contentPadding ?? defaultContentPadding,
        leadingPadding = leadingPadding ?? defaultLeadingPadding,
        trailingPadding = trailingPadding ?? defaultTrailingPadding,
        switchTitleStyles = switchTitleStyles ?? false,
        constraints = constraints ?? defaultConstraints;

  factory ListItem.checkbox({
    required VoidCallback onTap,
    required bool value,
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
  }) = _ListItemWithCheckbox;

  factory ListItem.user({
    required Widget title,
    required Widget subtitle,
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
    Widget? profilePictureWidget,
    bool verifiedBadge,
    bool iceBadge,
    bool? showProfilePictureIceBadge,
    bool isSelected,
    DateTime? timeago,
  }) = _ListItemUser;

  factory ListItem.text({
    required Widget title,
    required String value,
    Key? key,
    Color? backgroundColor,
  }) = _ListItemTextWithIcon;

  factory ListItem.textWithIcon({
    required Widget title,
    required String value,
    Widget? icon,
    Widget? secondary,
    Key? key,
    Color? backgroundColor,
  }) = _ListItemTextWithIcon;

  final Widget? leading;
  final Widget? title;
  final Widget? secondary;
  final Widget? subtitle;
  final bool switchTitleStyles;
  final Widget? trailing;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry trailingPadding;
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool? isSelected;

  static BorderRadius get defaultBorderRadius => BorderRadius.all(Radius.circular(16.0.s));

  static EdgeInsets get defaultContentPadding =>
      EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 10.0.s);

  static EdgeInsets get defaultLeadingPadding => EdgeInsets.only(right: 10.0.s);

  static EdgeInsets get defaultTrailingPadding => EdgeInsets.only(left: 10.0.s);

  static BoxConstraints get defaultConstraints => BoxConstraints(minHeight: 60.0.s);

  @override
  Widget build(BuildContext context) {
    return _buildMainContainer(
      context: context,
      child: Container(
        alignment: Alignment.center,
        constraints: constraints,
        padding: contentPadding,
        child: Column(
          children: [
            Row(
              children: [
                if (leading != null)
                  if (leadingPadding != EdgeInsets.zero)
                    Padding(padding: leadingPadding, child: leading)
                  else
                    leading!,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style: switchTitleStyles
                              ? _getDefaultSubtitleStyle(context)
                              : _getDefaultTitleStyle(context),
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        ),
                      if (subtitle != null)
                        DefaultTextStyle(
                          style: switchTitleStyles
                              ? _getDefaultTitleStyle(context)
                              : _getDefaultSubtitleStyle(context),
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                    ],
                  ),
                ),
                if (trailing != null)
                  if (trailingPadding != EdgeInsets.zero)
                    Padding(padding: trailingPadding, child: trailing)
                  else
                    trailing!,
              ],
            ),
            if (secondary != null)
              DefaultTextStyle(
                style: switchTitleStyles
                    ? _getDefaultSubtitleStyle(context)
                    : _getDefaultTitleStyle(context),
                child: secondary!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer({
    required Widget child,
    required BuildContext context,
  }) {
    final backgroundColor = _getBackgroundColor(context);
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
    return (isSelected ?? false)
        ? context.theme.appColors.primaryAccent
        : backgroundColor ?? context.theme.appColors.tertararyBackground;
  }

  TextStyle _getDefaultTitleStyle(BuildContext context) {
    return context.theme.appTextThemes.body.copyWith(
      color: (isSelected ?? false)
          ? context.theme.appColors.onPrimaryAccent
          : context.theme.appColors.primaryText,
    );
  }

  TextStyle _getDefaultSubtitleStyle(BuildContext context) {
    return context.theme.appTextThemes.caption3.copyWith(
      color: (isSelected ?? false)
          ? context.theme.appColors.onPrimaryAccent
          : context.theme.appColors.secondaryText,
    );
  }
}
