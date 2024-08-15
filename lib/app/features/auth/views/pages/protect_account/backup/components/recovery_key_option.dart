import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeyOption extends StatelessWidget {
  const RecoveryKeyOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });

  final String title;
  final String subtitle;
  final AssetGenImage iconAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextThemes;

    return RoundedCard.outlined(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconAsset.icon(
                  size: 16.0.s,
                  color: context.theme.appColors.onTertararyBackground,
                ),
                SizedBox(width: 6.0.s),
                Text(
                  title,
                  style: textTheme.caption2.copyWith(
                    color: context.theme.appColors.onTertararyBackground,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0.s),
            Text(
              subtitle,
              style: textTheme.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
