// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/data/models/share_button_type.dart';

class ShareActionButtons extends StatelessWidget {
  const ShareActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94.0.s,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: ShareButtonType.values.length,
        separatorBuilder: (_, __) => SizedBox(width: 25.0.s),
        itemBuilder: (context, index) => _ShareButton(index: index, onPressed: () {}),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.index,
    required this.onPressed,
  });

  final int index;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final type = ShareButtonType.values[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button.icon(
          icon: type.icon(context),
          onPressed: onPressed,
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
