// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryViewerHeader extends StatelessWidget {
  const StoryViewerHeader({required this.currentStory, super.key});
  final Story currentStory;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14.0.s,
      left: 16.0.s,
      right: 22.0.s,
      child: Row(
        children: [
          Avatar(
            imageUrl: currentStory.data.imageUrl,
            size: 30.0.s,
          ),
          SizedBox(width: 8.0.s),
          Expanded(
            child: _UserInfo(author: currentStory.data.author),
          ),
          const _HeaderActions(),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    required this.author,
  });

  final String author;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              author,
              style: context.theme.appTextThemes.subtitle3
                  .copyWith(color: context.theme.appColors.onPrimaryAccent),
            ),
            SizedBox(width: 4.0.s),
            Assets.svg.iconBadgeIcelogo.icon(size: 16.0.s),
            SizedBox(width: 4.0.s),
            Assets.svg.iconBadgeCompany.icon(size: 16.0.s),
          ],
        ),
        Text(
          '@$author',
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.onPrimaryAccent),
        ),
      ],
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Assets.svg.iconMoreStories.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          onTap: () => context.pop(),
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
