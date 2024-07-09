import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';

typedef TrailingWidgetBuilder = Widget Function(BuildContext);

class RoundedCard extends StatelessWidget {
  const RoundedCard._({
    required this.title,
    required this.trailing,
  });

  factory RoundedCard.text({
    required String title,
    required String value,
  }) {
    return RoundedCard._(
      title: title,
      trailing: (BuildContext context) => Text(
        value,
        style: context.theme.appTextThemes.body2,
      ),
    );
  }

  factory RoundedCard.textWithIcon({
    required String title,
    required String value,
    required Widget icon,
  }) {
    return RoundedCard._(
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

  factory RoundedCard.withSecondaryText({
    required String title,
    required String value,
    required Widget icon,
    required String secondaryValue,
  }) {
    return RoundedCard._(
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
