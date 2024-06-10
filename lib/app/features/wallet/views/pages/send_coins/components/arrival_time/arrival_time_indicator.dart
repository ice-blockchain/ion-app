import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ArrivalTimeIndicator extends StatelessWidget {
  const ArrivalTimeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Normal',
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.access_time,
                color: Colors.blue,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                '15 min',
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
