import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadMoreBuilder extends HookWidget {
  const LoadMoreBuilder({
    required this.builder,
    required this.slivers,
    required this.onLoadMore,
    required this.hasMore,
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

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (hasMore &&
            !loading.value &&
            metrics.maxScrollExtent - metrics.pixels <= loadMoreOffset) {
          loading.value = true;
          onLoadMore().whenComplete(() => loading.value = false);
        }
        return true;
      },
      child: builder(
        context,
        loading.value
            ? [
                ...slivers,
                SliverToBoxAdapter(child: Center(child: CircularProgressIndicator.adaptive()))
              ]
            : slivers,
      ),
    );
  }
}
