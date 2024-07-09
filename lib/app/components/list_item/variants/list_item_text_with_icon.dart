part of '../list_item.dart';

class _ListItemTextWithIcon extends ListItem {
  _ListItemTextWithIcon({
    required String value,
    required Widget icon,
    String? secondaryValue,
    super.title,
    super.key,
    super.backgroundColor,
  }) : super(
          trailing: _TrailingTextWithIcon(
            value: value,
            icon: icon,
            secondaryValue: secondaryValue,
          ),
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
    required this.icon,
    this.secondaryValue,
  });

  final String value;
  final Widget icon;
  final String? secondaryValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: 8.0.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.theme.appTextThemes.body2,
            ),
            if (secondaryValue.isNotEmpty)
              Text(
                secondaryValue!,
                style: context.theme.appTextThemes.caption3,
              ),
          ],
        ),
      ],
    );
  }
}
