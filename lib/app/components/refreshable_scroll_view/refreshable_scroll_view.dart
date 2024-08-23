import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RefreshableScrollView extends HookWidget {
  const RefreshableScrollView({
    super.key,
    required this.slivers,
    required this.onRefresh,
    this.sliverAppBar,
    this.refreshIndicatorEdgeOffset = 0,
    this.scrollController,
  });

  final Widget? sliverAppBar;

  final List<Widget> slivers;

  final Future<void> Function() onRefresh;

  final double refreshIndicatorEdgeOffset;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final controller = scrollController ?? useScrollController();

    final scrollView = CustomScrollView(
      controller: controller,
      slivers: [
        if (sliverAppBar != null) sliverAppBar!,
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
        ...slivers,
      ],
    );

    if (Platform.isIOS) {
      return scrollView;
    }

    return RefreshIndicator(
      edgeOffset: refreshIndicatorEdgeOffset,
      onRefresh: onRefresh,
      child: scrollView,
    );
  }
}
