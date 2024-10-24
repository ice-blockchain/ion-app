// SPDX-License-Identifier: ice License 1.0

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class RecoveryKeyOption extends StatelessWidget {
  const RecoveryKeyOption({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    super.key,
  });

  final String title;
  final String subtitle;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextThemes;

    return GestureDetector(
      onTap: () => Clipboard.setData(ClipboardData(text: subtitle)),
      child: RoundedCard.outlined(
        padding: EdgeInsets.symmetric(vertical: 20.0.s, horizontal: 16.0.s),
        child: Column(
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
            LayoutBuilder(
              builder: (context, constraints) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth - 20.0.s),
                    child: ExtendedText(
                      subtitle,
                      style: textTheme.subtitle,
                      maxLines: 1,
                      overflowWidget: TextOverflowWidget(
                        position: TextOverflowPosition.middle,
                        child: Text('...', style: textTheme.subtitle),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0.s),
                  Assets.svg.iconBlockCopyBlue.icon(size: 16.0.s),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
