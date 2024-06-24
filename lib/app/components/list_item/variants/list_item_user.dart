part of '../list_item.dart';

class _ListItemUser extends ListItem {
  _ListItemUser({
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
    bool verifiedBadge = false,
    bool iceBadge = false,
    super.isSelected,
    DateTime? timeago,
  }) : super(
          leading: leading ??
              (profilePicture != null
                  ? Avatar(
                      size: avatarSize,
                      imageUrl: profilePicture,
                    )
                  : null),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding:
              leadingPadding ?? EdgeInsets.only(right: UiSize.xxSmall),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: <Widget>[
              // Flexible allows text to be truncated on overflow
              Flexible(child: title),
              if (iceBadge)
                Padding(
                  padding: EdgeInsets.only(left: UiSize.xxxSmall),
                  child: Assets.images.icons.iconBadgeIcelogo
                      .icon(size: badgeSize),
                ),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsets.only(left: UiSize.xxxSmall),
                  child:
                      Assets.images.icons.iconBadgeVerify.icon(size: badgeSize),
                ),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              // Flexible allows text to be truncated on overflow
              Flexible(child: subtitle),
              if (timeago != null) _TimeAgo(date: timeago),
            ],
          ),
        );

  static double get avatarSize => 30.0.s;

  static double get badgeSize => UiSize.medium;

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

class _TimeAgo extends StatelessWidget {
  const _TimeAgo({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Timeago(
      date: date,
      builder: (BuildContext context, String value) => Text(' • $value'),
      locale: 'en_short',
    );
  }
}
