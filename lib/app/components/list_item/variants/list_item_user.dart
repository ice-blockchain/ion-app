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
    Widget? profilePictureWidget,
    bool verifiedBadge = false,
    bool iceBadge = false,
    bool? showProfilePictureIceBadge,
    super.isSelected,
    DateTime? timeago,
  }) : super(
          leading: leading ??
              (profilePicture != null || profilePictureWidget != null
                  ? Avatar(
                      size: avatarSize,
                      imageUrl: profilePicture,
                      iceBadge: showProfilePictureIceBadge ?? false,
                      imageWidget: profilePictureWidget,
                    )
                  : null),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsets.only(right: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: <Widget>[
              Flexible(child: title),
              if (iceBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child: Assets.images.icons.iconBadgeIcelogo
                      .icon(size: badgeSize),
                ),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child:
                      Assets.images.icons.iconBadgeVerify.icon(size: badgeSize),
                ),
            ],
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns the Column to the top of the Row
            children: <Widget>[
              Flexible(child: subtitle),
              if (timeago != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TimeAgo(date: timeago),
                  ],
                ),
            ],
          ),
        );

  static double get avatarSize => 30.0.s;

  static double get badgeSize => 16.0.s;

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
