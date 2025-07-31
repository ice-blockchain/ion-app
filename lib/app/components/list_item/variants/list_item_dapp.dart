// SPDX-License-Identifier: ice License 1.0

part of '../list_item.dart';

class _ListItemDApp extends ListItem {
  _ListItemDApp({
    required Widget title,
    required Widget subtitle,
    super.key,
    super.border,
    super.trailingPadding,
    super.backgroundColor,
    super.onTap,
    super.trailing,
    Widget? leading,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    BoxConstraints? constraints,
    String? profilePicture,
    Widget? profilePictureWidget,
    bool verifiedBadge = false,
    super.isSelected,
  }) : super(
          leading: leading ??
              Avatar(
                size: defaultAvatarSize,
                imageUrl: profilePicture,
                imageWidget: profilePictureWidget,
              ),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsetsDirectional.only(end: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: [
              Flexible(child: title),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.0.s),
                  child: Assets.svg.iconBadgeVerify.icon(size: defaultBadgeSize),
                ),
            ],
          ),
          subtitle: subtitle,
        );

  static double get defaultAvatarSize => 30.0.s;

  static double get defaultBadgeSize => 16.0.s;

  @override
  Color _getBackgroundColor(BuildContext context) {
    return (isSelected ?? false)
        ? context.theme.appColors.primaryAccent
        : backgroundColor ?? Colors.transparent;
  }

  @override
  TextStyle _getDefaultTitleStyle(BuildContext context) {
    return context.theme.appTextThemes.subtitle3.copyWith(
      color: (isSelected ?? false)
          ? context.theme.appColors.onPrimaryAccent
          : context.theme.appColors.primaryText,
    );
  }

  @override
  TextStyle _getDefaultSubtitleStyle(BuildContext context) {
    return context.theme.appTextThemes.caption.copyWith(
      color: (isSelected ?? false)
          ? context.theme.appColors.onPrimaryAccent
          : context.theme.appColors.terararyText,
    );
  }
}
