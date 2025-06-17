// SPDX-License-Identifier: ice License 1.0

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/copy/copy_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class RecoveryKeyOption extends StatelessWidget {
  const RecoveryKeyOption({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.onTap,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextThemes;
    return CopyBuilder(
      defaultIcon: IconAssetColored(
        iconAsset,
        size: 16.0,
        color: context.theme.appColors.onTertararyBackground,
      ),
      copiedIcon: IconAsset(Assets.svgIconBlockCheckGreen, size: 16.0),
      defaultText: title,
      defaultBorderColor: context.theme.appColors.onTerararyFill,
      builder: (context, onCopy, content) {
        return GestureDetector(
          onTap: enabled
              ? () {
                  onCopy(subtitle);
                  onTap();
                }
              : null,
          child: RoundedCard.outlined(
            padding: EdgeInsets.symmetric(vertical: 20.0.s, horizontal: 16.0.s),
            borderColor: content.borderColor,
            child: Opacity(
              opacity: enabled ? 1.0 : 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      content.icon,
                      SizedBox(width: 6.0.s),
                      Text(
                        content.text,
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
                              align: TextOverflowAlign.center,
                              child: Text('...', style: textTheme.subtitle),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0.s),
                        IconAsset(Assets.svgIconBlockCopyBlue, size: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
