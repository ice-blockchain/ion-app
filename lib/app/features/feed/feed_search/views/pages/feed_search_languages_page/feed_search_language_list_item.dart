// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedSearchLanguageListItem extends StatelessWidget {
  const FeedSearchLanguageListItem({
    required this.language,
    required this.selected,
    super.key,
  });

  final Language language;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: SizedBox(
        height: 44.0.s,
        child: Row(
          children: [
            Text(language.flag, style: TextStyle(fontSize: 21.0.s)),
            SizedBox(width: 16.0.s),
            Expanded(
              child: Text(
                language.name,
                style: context.theme.appTextThemes.subtitle2.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ),
            if (selected) Assets.svg.iconBlockCheckboxOnblue.icon(),
          ],
        ),
      ),
    );
  }
}
