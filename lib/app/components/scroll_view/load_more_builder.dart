// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';

class LoadMoreBuilder extends HookWidget {
  LoadMoreBuilder({
    required this.slivers,
    required this.onLoadMore,
    required this.hasMore,
    Widget Function(BuildContext context, List<Widget> slivers)? builder,
    this.loadMoreOffset,
    super.key,
  }) : builder = builder ??
            ((BuildContext context, List<Widget> slivers) => CustomScrollView(slivers: slivers));

  final Widget Function(BuildContext context, List<Widget> slivers) builder;

  final List<Widget> slivers;

  final Future<void> Function() onLoadMore;

  final double? loadMoreOffset;

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onMetricsChanged(notification, loading),
      child: builder(
        context,
        loading.value
            ? [
                ...slivers,
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0.s),
                    child: const Center(child: CircularProgressIndicator.adaptive()),
                  ),
                ),
              ]
            : slivers,
      ),
    );
  }

  bool _onMetricsChanged(
    ScrollNotification notification,
    ValueNotifier<bool> loading,
  ) {
    final metrics = notification.metrics;
    final loadMoreOffset = this.loadMoreOffset ?? metrics.viewportDimension;
    if (hasMore && !loading.value && metrics.maxScrollExtent - metrics.pixels <= loadMoreOffset) {
      loading.value = true;
      onLoadMore().whenComplete(() => loading.value = false);
    }
    return true;
  }
}
