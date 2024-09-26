import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/extensions/extensions.dart';

class RestoreMenuItem extends StatelessWidget {
  const RestoreMenuItem({
    required this.icon, required this.title, required this.description, required this.onPressed, super.key,
  });

  final Widget icon;

  final String title;

  final String description;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: RoundedCard.filled(
        padding: EdgeInsets.all(16.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            icon,
            SizedBox(height: 8.0.s),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            SizedBox(height: 4.0.s),
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
