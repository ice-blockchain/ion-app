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
    super.isSelected,
    DateTime? timeago,
  })  : assert(
          profilePicture == null || profilePictureWidget == null,
          'Either profilePicture or profilePictureWidget must be null',
        ),
        super(
          leading: leading ??
              _buildLeading(
                profilePicture,
                profilePictureWidget,
                verifiedBadge,
                iceBadge,
              ),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsets.only(right: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: <Widget>[
              // Flexible allows text to be truncated on overflow
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
            children: <Widget>[
              // Flexible allows text to be truncated on overflow
              Flexible(child: subtitle),
              if (timeago != null) _TimeAgo(date: timeago),
            ],
          ),
        );

  static double get avatarSize => 30.0.s;

  static double get badgeSize => 16.0.s;

  static Widget _buildLeading(
    String? profilePicture,
    Widget? profilePictureWidget,
    bool verifiedBadge,
    bool iceBadge,
  ) {
    if ((profilePictureWidget != null) || (profilePicture != null)) {
      return Stack(
        children: [
          if (profilePictureWidget != null)
            profilePictureWidget
          else if (profilePicture != null)
            Avatar(size: avatarSize, imageUrl: profilePicture),
          if (verifiedBadge)
            const Positioned(
              bottom: 0,
              right: 0,
              child: Icon(Icons.verified, size: 16),
            ),
          if (iceBadge)
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.ac_unit, size: 16),
            ),
        ],
      );
    } else {
      return Container();
    }
  }

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
