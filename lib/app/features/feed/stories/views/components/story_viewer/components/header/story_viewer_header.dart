// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';
import 'package:ion/app/utils/username.dart';

class StoryViewerHeader extends StatelessWidget {
  const StoryViewerHeader({
    required this.currentStory,
    super.key,
  });

  final Story currentStory;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14.0.s,
      left: 16.0.s,
      right: 22.0.s,
      child: ListItem.user(
        profilePicture: currentStory.data.imageUrl,
        title: Text(
          currentStory.data.author,
          style: context.theme.appTextThemes.subtitle3.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        subtitle: Text(
          prefixUsername(
            username: currentStory.data.author,
            context: context,
          ),
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        iceBadge: Random().nextBool(),
        verifiedBadge: Random().nextBool(),
        trailing: HeaderActions(story: currentStory),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        constraints: BoxConstraints(minHeight: 30.0.s),
      ),
    );
  }
}
