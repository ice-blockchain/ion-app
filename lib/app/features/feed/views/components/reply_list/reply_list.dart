// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyList extends ConsumerWidget {
  const ReplyList({
    required this.eventReference,
    this.headers,
    super.key,
  });

  final List<Widget>? headers;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replies = ref.watch(repliesProvider(eventReference));
    final entities = replies?.data.items;
    final hasMoreReplies =
        ref.watch(repliesProvider(eventReference).select((state) => (state?.hasMore).falseOrValue));

    return LoadMoreBuilder(
      hasMore: hasMoreReplies,
      onLoadMore: () => ref.read(repliesProvider(eventReference).notifier).loadMore(eventReference),
      slivers: [
        if (headers != null) ...headers!,
        if (entities == null)
          const EntitiesListSkeleton()
        else if (entities.isEmpty)
          const _EmptyState()
        else
          EntitiesList(
            entities: entities.toList(),
            separatorHeight: 1.0.s,
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        child: EmptyList(
          asset: Assets.svg.walletIconProfileEmptyprofile,
          title: context.i18n.feed_replies_empty,
        ),
      ),
    );
  }
}
