// SPDX-License-Identifier: ice License 1.0

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
    bool showProfilePictureIceBadge = false,
    bool ntfAvatar = false,
    super.isSelected,
    DateTime? timeago,
  }) : super(
          leading: leading ??
              (profilePicture != null || profilePictureWidget != null
                  ? Avatar(
                      size: avatarSize,
                      imageUrl: profilePicture,
                      badge: showProfilePictureIceBadge ? const _IceBadge() : null,
                      imageWidget: profilePictureWidget,
                      hexagon: ntfAvatar,
                    )
                  : null),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsets.only(right: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: [
              Flexible(child: title),
              if (iceBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child: Assets.svg.iconBadgeIcelogo.icon(size: badgeSize),
                ),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child: Assets.svg.iconBadgeVerify.icon(size: badgeSize),
                ),
            ],
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns the Column to the top of the Row
            children: [
              Flexible(child: subtitle),
              if (timeago != null) _TimeAgo(date: timeago),
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

class _IceBadge extends StatelessWidget {
  const _IceBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -2.0.s,
      right: -2.0.s,
      child: Container(
        width: 12.0.s,
        height: 12.0.s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.5.s),
          border: Border.all(
            width: 1.0.s,
            color: context.theme.appColors.secondaryBackground,
          ),
          color: context.theme.appColors.darkBlue,
        ),
        child: Center(
          child: Assets.svg.iconIcelogoSecuredby.icon(
            color: context.theme.appColors.secondaryBackground,
            size: 10.0.s,
          ),
        ),
      ),
    );
  }
}

class ListItemUserShape extends StatelessWidget {
  const ListItemUserShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.s),
        color: Colors.white,
      ),
    );
  }
}
