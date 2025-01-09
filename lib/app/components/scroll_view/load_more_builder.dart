// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadMoreBuilder extends HookWidget {
  const LoadMoreBuilder({
    required this.builder,
    required this.slivers,
    required this.onLoadMore,
    required this.hasMore,
    super.key,
    this.loadMoreOffset = 300,
  });

  final Widget Function(BuildContext context, List<Widget> slivers) builder;

  final List<Widget> slivers;

  final Future<void> Function() onLoadMore;

  final double loadMoreOffset;

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    // A ScrollMetricsNotification allows listeners to be notified for an
    // initial state, as well as if the content dimensions change without
    // scrolling. Useful when there is not enough content to scroll,
    // but hasMore is true and more content should be loaded.
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) => _onMetricsChanged(notification.asScrollUpdate(), loading),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onMetricsChanged(notification, loading),
        child: builder(
          context,
          loading.value
              ? [
                  ...slivers,
                  const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                ]
              : slivers,
        ),
      ),
    );
  }

  bool _onMetricsChanged(ScrollNotification notification, ValueNotifier<bool> loading) {
    final metrics = notification.metrics;
    if (hasMore && !loading.value && metrics.maxScrollExtent - metrics.pixels <= loadMoreOffset) {
      loading.value = true;
      onLoadMore().whenComplete(() => loading.value = false);
    }
    return true;
  }
}
