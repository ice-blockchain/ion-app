import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullToRefreshBuilder extends StatelessWidget {
  const PullToRefreshBuilder({required this.builder, required this.slivers, required this.onRefresh, super.key,
    this.refreshIndicatorEdgeOffset = 0,
    this.sliverAppBar,
  });

  final Widget Function(BuildContext context, List<Widget> slivers) builder;

  final Widget? sliverAppBar;

  final List<Widget> slivers;

  final Future<void> Function() onRefresh;

  final double refreshIndicatorEdgeOffset;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return builder(context, [
        if (sliverAppBar != null) sliverAppBar!,
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        ...slivers,
      ]);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      edgeOffset: refreshIndicatorEdgeOffset,
      child: builder(context, [if (sliverAppBar != null) sliverAppBar!, ...slivers]),
    );
  }
}
