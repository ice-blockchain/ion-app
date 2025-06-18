// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/replies_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyList extends ConsumerWidget {
  const ReplyList({
    required this.eventReference,
    this.headers,
    this.onPullToRefresh,
    super.key,
  });

  final List<Widget>? headers;
  final EventReference eventReference;
  final VoidCallback? onPullToRefresh;

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
            refs: entities.map((entity) => entity.toEventReference()).toList(),
            separatorHeight: 1.0.s,
            onVideoTap: ({
              required String eventReference,
              required int initialMediaIndex,
              String? framedEventReference,
            }) =>
                ReplyListVideosRoute(
              eventReference: eventReference,
              initialMediaIndex: initialMediaIndex,
              parentEventReference: this.eventReference.encode(),
              framedEventReference: framedEventReference,
            ).push<void>(context),
          ),
      ],
      builder: (context, slivers) => PullToRefreshBuilder(
        slivers: slivers,
        onRefresh: () => _onRefresh(ref),
        builder: (BuildContext context, List<Widget> slivers) => CustomScrollView(slivers: slivers),
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    ref.invalidate(
      entitiesPagedDataProvider(
        ref.read(repliesDataSourceProvider(eventReference: eventReference)),
      ),
    );
    onPullToRefresh?.call();
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
          asset: Assets.svgWalletIconProfileEmptyprofile,
          title: context.i18n.feed_replies_empty,
        ),
      ),
    );
  }
}
