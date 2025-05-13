// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/scroll_view/ion_pull_to_refresh_loading_indicator.dart';

class PullToRefreshBuilder extends HookWidget {
  PullToRefreshBuilder({
    required this.slivers,
    required this.onRefresh,
    Widget Function(BuildContext context, List<Widget> slivers)? builder,
    this.refreshIndicatorEdgeOffset = 0,
    this.sliverAppBar,
    super.key,
  }) : builder = builder ??
            ((BuildContext context, List<Widget> slivers) => CustomScrollView(slivers: slivers));

  final Widget Function(BuildContext context, List<Widget> slivers) builder;

  final Widget? sliverAppBar;

  final List<Widget> slivers;

  final Future<void> Function() onRefresh;

  final double refreshIndicatorEdgeOffset;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isIOS) {
      return builder(context, [
        if (sliverAppBar != null) sliverAppBar!,
        CupertinoSliverRefreshControl(
          onRefresh: _onRefresh,
          builder: (_, refreshState, pulledExtent, refreshTriggerPullDistance, ___) =>
              IonPullToRefreshLoadingIndicator(
            refreshState: refreshState,
            pulledExtent: pulledExtent,
            refreshTriggerPullDistance: refreshTriggerPullDistance,
          ),
        ),
        ...slivers,
      ]);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      edgeOffset: refreshIndicatorEdgeOffset,
      child: builder(context, [
        if (sliverAppBar != null) sliverAppBar!,
        ...slivers,
      ]),
    );
  }

  // Add some minimal delay to prevent the refresh indicator from hiding too quickly
  Future<void> _onRefresh() => (onRefresh(), Future<void>.delayed(const Duration(seconds: 1))).wait;
}
