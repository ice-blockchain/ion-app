// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/shadow/svg_shadow.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/story_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({required this.post, super.key});

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StoryContextMenu(
          pubkey: post.masterPubkey,
          child: SvgShadow(
            child: Assets.svg.iconMoreStories.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
          ),
        ),
        SizedBox(width: 16.0.s),
        GestureDetector(
          child: SvgShadow(
            child: Assets.svg.iconSheetClose.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
          ),
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
