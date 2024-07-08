import 'package:flutter/material.dart';
import 'package:ice/app/components/rounded_card/card.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TitleValueBlock extends StatelessWidget {
  const TitleValueBlock({
    super.key,
    this.title,
    this.icon,
    this.value,
  });

  final String? title;
  final Widget? icon;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (title != null)
            Text(
              title!,
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 6.0.s),
                  child: icon,
                ),
              if (value != null)
                Text(
                  value!,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
