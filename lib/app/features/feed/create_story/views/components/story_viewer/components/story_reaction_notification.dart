// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryReactionNotification extends StatelessWidget {
  const StoryReactionNotification({
    required this.emoji,
    super.key,
  });

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0.s),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0.s,
              vertical: 8.0.s,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16.0.s),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.i18n.reaction_was_sent,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                ),
                Text(
                  ' emoji',
                  style: TextStyle(
                    fontSize: 16.0.s,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
