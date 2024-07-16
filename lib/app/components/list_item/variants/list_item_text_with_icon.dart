part of '../list_item.dart';

class _ListItemTextWithIcon extends ListItem {
  _ListItemTextWithIcon({
    required String value,
    Widget? icon,
    super.secondary,
    super.title,
    super.key,
    super.backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    BoxConstraints? constraints,
  }) : super(
          trailing: _TrailingTextWithIcon(
            value: value,
            icon: icon,
            secondary: secondary,
          ),
          trailingPadding: EdgeInsets.zero,
          contentPadding: contentPadding ?? ListItem.defaultTextContentPadding,
          constraints: constraints ?? const BoxConstraints(),
        );

  @override
  Color _getBackgroundColor(BuildContext context) {
    return context.theme.appColors.tertararyBackground;
  }

  @override
  TextStyle _getDefaultTitleStyle(BuildContext context) {
    return context.theme.appTextThemes.caption3.copyWith(
      color: context.theme.appColors.secondaryText,
    );
  }
}

class _TrailingTextWithIcon extends StatelessWidget {
  const _TrailingTextWithIcon({
    required this.value,
    this.icon,
    this.secondary,
  });

  final String value;
  final Widget? icon;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: 8.0.s),
            ],
            Flexible(
              child: Text(
                value,
                style: context.theme.appTextThemes.body2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
