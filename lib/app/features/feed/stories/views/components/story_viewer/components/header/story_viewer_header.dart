// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/username.dart';

class StoryViewerHeader extends ConsumerWidget {
  const StoryViewerHeader({
    required this.currentPost,
    super.key,
  });

  final PostEntity currentPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataEntity = ref.watch(userMetadataProvider(currentPost.pubkey));

    return userMetadataEntity.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) return const SizedBox.shrink();

        return Positioned(
          top: 14.0.s,
          left: 16.0.s,
          right: 22.0.s,
          child: GestureDetector(
            onTap: () => StoryProfileRoute(pubkey: currentPost.pubkey).push<void>(context),
            child: ListItem.user(
              profilePicture: userMetadata.data.picture,
              title: Text(
                userMetadata.data.name,
                style: context.theme.appTextThemes.subtitle3.copyWith(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
              ),
              subtitle: Text(
                prefixUsername(
                  username: userMetadata.data.displayName,
                  context: context,
                ),
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
              ),
              verifiedBadge: userMetadata.data.verified,
              trailing: HeaderActions(post: currentPost),
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              constraints: BoxConstraints(minHeight: 30.0.s),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
