// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class EntityCommentsButton extends ConsumerWidget {
  const EntityCommentsButton({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesCount = ref.watch(repliesCountProvider(eventReference));

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        CreatePostRoute(parentEvent: eventReference.toString()).push<void>(context);
      },
      child: FeedItemActionButton(
        icon: Assets.svg.iconBlockComment.icon(size: 16.0.s),
        activeIcon: Assets.svg.iconBlockCommenton.icon(size: 16.0.s),
        value: repliesCount != null ? formatDoubleCompact(repliesCount) : '',
        activeColor: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
