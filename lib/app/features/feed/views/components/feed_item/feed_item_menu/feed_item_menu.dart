// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu_item.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/follow_feed_menu_item.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedItemMenu extends ConsumerWidget {
  const FeedItemMenu({required this.pubkey, super.key});

  static double get iconSize => 20.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata =
        ref.watch(nostrCacheProvider.select(cacheSelector<UserMetadataEntity>(pubkey)));

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: FeedItemMenuItem(
              label: context.i18n.post_menu_not_interested,
              icon: Assets.svg.iconNotinterested.icon(size: iconSize),
              onPressed: closeMenu,
            ),
          ),
          SizedBox(height: 14.0.s),
          OverlayMenuContainer(
            child: Column(
              children: [
                FollowFeedMenuItem(userMetadata: userMetadata),
                FeedItemMenuItem(
                  label: context.i18n.post_menu_block_nickname(userMetadata.data.name),
                  icon: Assets.svg.iconBlock.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
                FeedItemMenuItem(
                  label: context.i18n.post_menu_report_post,
                  icon: Assets.svg.iconReport.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
              ],
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}
