// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PullToRefreshBuilder extends HookWidget {
  const PullToRefreshBuilder({
    required this.builder,
    required this.slivers,
    required this.onRefresh,
    super.key,
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
    if (!kIsWeb && Platform.isIOS) {
      return builder(context, [
        if (sliverAppBar != null) sliverAppBar!,
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        ...slivers,
      ]);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      edgeOffset: refreshIndicatorEdgeOffset,
      child: builder(context, [
        if (sliverAppBar != null) sliverAppBar!,
        ...slivers,
      ]),
    );
  }
}
