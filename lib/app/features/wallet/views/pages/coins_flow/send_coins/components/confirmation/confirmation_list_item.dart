import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';

typedef TrailingWidgetBuilder = Widget Function(BuildContext);

class ConfirmationListItem extends StatelessWidget {
  const ConfirmationListItem._({
    required this.title,
    required this.trailing,
  });

  factory ConfirmationListItem.text({
    required String title,
    required String value,
  }) {
    return ConfirmationListItem._(
      title: title,
      trailing: (BuildContext context) => Text(
        value,
        style: context.theme.appTextThemes.caption3,
      ),
    );
  }

  factory ConfirmationListItem.textWithIcon({
    required String title,
    required String value,
    required Widget icon,
  }) {
    return ConfirmationListItem._(
      title: title,
      trailing: (BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 8.0.s),
          Text(
            value,
            style: context.theme.appTextThemes.body2,
          ),
        ],
      ),
    );
  }

  factory ConfirmationListItem.withSecondaryText({
    required String title,
    required String value,
    required Widget icon,
    required String secondaryValue,
  }) {
    return ConfirmationListItem._(
      title: title,
      trailing: (BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: 8.0.s),
              Text(
                value,
                style: context.theme.appTextThemes.body2,
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Text(
            secondaryValue,
            style: context.theme.appTextThemes.caption3,
          ),
        ],
      ),
    );
  }

  final String title;
  final TrailingWidgetBuilder trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    return ListItem(
      title: Text(
        title,
        style: textTheme.caption3.copyWith(color: colors.secondaryText),
      ),
      trailing: trailing(context),
      backgroundColor: colors.tertararyBackground,
    );
  }
}
