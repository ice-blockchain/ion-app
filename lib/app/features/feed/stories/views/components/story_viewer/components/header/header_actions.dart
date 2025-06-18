// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/shadow/svg_shadow.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/story_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class HeaderActions extends ConsumerWidget {
  const HeaderActions({required this.post, super.key});

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconMoreColor = context.theme.appColors.onPrimaryAccent;

    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    final isCurrentUser = currentUserPubkey == post.masterPubkey;

    return Row(
      children: [
        StoryContextMenu(
          pubkey: post.masterPubkey,
          post: post,
          isCurrentUser: isCurrentUser,
          child: SvgShadow(
            child: Assets.svgIconMoreStories.icon(color: iconMoreColor),
          ),
        ),
        SizedBox(width: 16.0.s),
        GestureDetector(
          child: SvgShadow(
            child: Assets.svgIconSheetClose.icon(color: iconMoreColor),
          ),
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
