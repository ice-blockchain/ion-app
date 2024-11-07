// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/data/models/share_button_type.dart';

class ShareActionButtons extends StatelessWidget {
  const ShareActionButtons({super.key});

  static double get iconSize => 28.0.s;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0.s),
        child: SeparatedRow(
          separator: SizedBox(width: 25.0.s),
          children: ShareButtonType.values.map((type) => _ShareButton(type: type)).toList(),
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.type,
  });

  final ShareButtonType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button.icon(
          icon: type.icon(context),
          onPressed: () {},
          fixedSize: Size.square(56.0.s),
          type: ButtonType.secondary,
          borderRadius: BorderRadius.circular(16.0.s),
          borderColor: context.theme.appColors.onTerararyFill,
          backgroundColor: context.theme.appColors.tertararyBackground,
        ),
        SizedBox(height: 6.0.s),
        Text(
          type.label(context),
          style: context.theme.appTextThemes.caption2,
        ),
      ],
    );
  }
}
