import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class EntityRepostsButton extends ConsumerWidget {
  const EntityRepostsButton({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repostsCountEntity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.reposts,
          ),
        ),
      ),
    );

    final quotesCountEntity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.quotes,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        RepostOptionsModalRoute(eventReference: eventReference.toString()).push<void>(context);
      },
      child: FeedItemActionButton(
        icon: Assets.svg.iconBlockRepost.icon(size: 16.0.s),
        activeIcon: Assets.svg.iconBlockRepost.icon(
          size: 16.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
        value: repostsCountEntity != null && quotesCountEntity != null
            ? formatDoubleCompact(
                (repostsCountEntity.data.content as int) + (quotesCountEntity.data.content as int),
              )
            : '',
        activeColor: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
