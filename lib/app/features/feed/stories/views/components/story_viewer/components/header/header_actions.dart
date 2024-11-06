// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/story_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({required this.story, super.key});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StoryContextMenu(
          pubkey: story.data.authorId,
          child: Assets.svg.iconMoreStories.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        SizedBox(width: 16.0.s),
        GestureDetector(
          child: Assets.svg.iconSheetClose.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
