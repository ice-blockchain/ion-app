// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu_item.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteFeedItemMenu extends ConsumerWidget {
  const DeleteFeedItemMenu({
    required this.entity,
    required this.kind,
    this.iconColor,
    this.onDelete,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final CacheableEntity entity;
  final int kind;
  final Color? iconColor;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: UserInfoMenuItem(
              label: context.i18n.post_menu_delete,
              labelColor: context.theme.appColors.attentionRed,
              icon: Assets.svg.iconBlockDelete.icon(
                size: iconSize,
                color: context.theme.appColors.attentionRed,
              ),
              onPressed: () async {
                closeMenu();
                await _deleteEntity(ref, entity);
                onDelete?.call();
              },
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: iconColor ?? context.theme.appColors.onTertararyBackground,
      ),
    );
  }

  Future<void> _deleteEntity(WidgetRef ref, CacheableEntity entity) async {
    final deletionRequest = DeletionRequest(
      events: [EventToDelete(eventId: entity.id, kind: kind)],
    );

    await ref
        .read(ionConnectNotifierProvider.notifier)
        .sendEntityData(deletionRequest, cache: false);

    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);

    final feedDataSources = ref.read(feedPostsDataSourceProvider) ?? [];

    if (feedDataSources.isNotEmpty) {
      await ref.read(entitiesPagedDataProvider(feedDataSources).notifier).deleteEntity(entity);
    }
  }
}
