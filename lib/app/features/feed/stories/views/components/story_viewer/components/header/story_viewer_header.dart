// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/username.dart';

class StoryViewerHeader extends HookWidget {
  const StoryViewerHeader({
    required this.pubkey,
    required this.currentStory,
    super.key,
  });

  final String pubkey;
  final Story currentStory;

  @override
  Widget build(BuildContext context) {
    final iceBadgeState = useState(Random().nextBool());
    final verifiedBadgeState = useState(Random().nextBool());

    return Positioned(
      top: 14.0.s,
      left: 16.0.s,
      right: 22.0.s,
      child: GestureDetector(
        onTap: () => ProfileRoute(pubkey: pubkey).go(context),
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
          iceBadge: iceBadgeState.value,
          verifiedBadge: verifiedBadgeState.value,
          trailing: HeaderActions(story: currentStory),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          constraints: BoxConstraints(minHeight: 30.0.s),
        ),
      ),
    );
  }
}
