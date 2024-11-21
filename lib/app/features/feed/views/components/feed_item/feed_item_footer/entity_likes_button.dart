import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/feed/data/models/entities/reactions_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class EntityLikesButton extends ConsumerWidget {
  const EntityLikesButton({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactionsCountEntity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity<Map<String, int>>>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.reactions,
          ),
        ),
      ),
    );

    final numberOfLikes = reactionsCountEntity?.data.content[ReactionsEntity.likeSymbol];

    return GestureDetector(
      onTap: HapticFeedback.lightImpact,
      child: FeedItemActionButton(
        icon: Assets.svg.iconVideoLikeOff.icon(
          size: 18.0.s,
          color: context.theme.appColors.onTertararyBackground,
        ),
        activeIcon: Assets.svg.iconVideoLikeOn.icon(
          size: 18.0.s,
          color: context.theme.appColors.attentionRed,
        ),
        value: numberOfLikes != null ? formatDoubleCompact(numberOfLikes) : '',
        activeColor: context.theme.appColors.attentionRed,
      ),
    );
  }
}
