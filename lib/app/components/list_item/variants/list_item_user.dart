// SPDX-License-Identifier: ice License 1.0

part of '../list_item.dart';

class _ListItemUser extends ListItem {
  _ListItemUser({
    required String pubkey,
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
    bool verifiedBadge = false,
    bool iceBadge = false,
    super.isSelected,

    /// Pass a resized value (e.g., 30.0.s) instead of a raw value (e.g., 30.0)
    /// to ensure proper scaling across different screen sizes.
    double? avatarSize,
  }) : super(
          leading: leading ??
              IonConnectAvatar(
                size: avatarSize ?? ListItem.defaultAvatarSize,
                pubkey: pubkey,
              ),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsetsDirectional.only(end: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: [
              Flexible(child: title),
              if (iceBadge)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.0.s),
                  child: Assets.svgIconBadgeIcelogo.icon(size: defaultBadgeSize),
                ),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.0.s),
                  child: Assets.svgIconBadgeVerify.icon(size: defaultBadgeSize),
                ),
            ],
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns the Column to the top of the Row
            children: [
              Flexible(child: subtitle),
            ],
          ),
        );

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
          : context.theme.appColors.tertararyText,
    );
  }
}

class ListItemUserShape extends StatelessWidget {
  const ListItemUserShape({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.s),
        color: color ?? Colors.white,
      ),
    );
  }
}
