part of '../list_item.dart';

class _ListItemUser extends ListItem {
  _ListItemUser({
    super.key,
    super.border,
    super.trailingPadding,
    super.backgroundColor,
    super.onTap,
    super.trailing,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? leadingPadding,
    BoxConstraints? constraints,
    required String name,
    required String nickname,
    required String profilePicture,
    bool verifiedBadge = false,
    bool iceBadge = false,
  }) : super(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0.s),
            child: CachedNetworkImage(
              imageUrl: getAdaptiveImageUrl(profilePicture, avatarSize),
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.fitWidth,
            ),
          ),
          borderRadius: borderRadius ?? BorderRadius.zero,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          leadingPadding: leadingPadding ?? EdgeInsets.only(right: 8.0.s),
          constraints: constraints ?? const BoxConstraints(),
          title: Row(
            children: <Widget>[
              Text(name),
              if (iceBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child: Assets.images.icons.iconBadgeIcelogo
                      .image(width: badgeSize, height: badgeSize),
                ),
              if (verifiedBadge)
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
                  child: Assets.images.icons.iconBadgeVerify
                      .image(width: badgeSize, height: badgeSize),
                ),
            ],
          ),
          subtitle: Text(nickname),
        );

  static double get avatarSize => 30.0.s;
  static double get badgeSize => 16.0.s;

  @override
  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ?? Colors.transparent;
  }

  @override
  TextStyle _getDefaultTitleStyle(BuildContext context) {
    //TODO::change to subtitle3
    return context.theme.appTextThemes.subtitle2.copyWith(
      color: context.theme.appColors.primaryText,
    );
  }

  @override
  TextStyle _getDefaultSubtitleStyle(BuildContext context) {
    return context.theme.appTextThemes.caption.copyWith(
      color: context.theme.appColors.tertararyText,
    );
  }
}
