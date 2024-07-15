part of '../list_item.dart';

class _ListItemTextWithIcon extends ListItem {
  _ListItemTextWithIcon({
    required String value,
    Widget? icon,
    String? secondaryValue,
    super.title,
    super.key,
    super.backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    BoxConstraints? constraints,
  }) : super(
          trailing: _TrailingTextWithIcon(
            value: value,
            icon: icon,
            secondaryValue: secondaryValue,
          ),
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
    this.secondaryValue,
  });

  final String value;
  final Widget? icon;
  final String? secondaryValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ?? const SizedBox.shrink(),
        SizedBox(width: 8.0.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.theme.appTextThemes.body2,
            ),
            //TODO(denisM): become multiline secondaryValue
            if (secondaryValue.isNotEmpty)
              Text(
                secondaryValue!,
                style: context.theme.appTextThemes.caption3.copyWith(),
                maxLines: 2,
              ),
          ],
        ),
      ],
    );
  }
}
