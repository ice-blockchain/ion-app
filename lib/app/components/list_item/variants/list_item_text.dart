part of '../list_item.dart';

class _ListItemText extends ListItem {
  _ListItemText({
    required String value,
    super.title,
    super.key,
    super.backgroundColor,
  }) : super(
          trailing: _TrailingText(value: value),
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

class _TrailingText extends StatelessWidget {
  const _TrailingText({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.theme.appTextThemes.body2,
    );
  }
}
