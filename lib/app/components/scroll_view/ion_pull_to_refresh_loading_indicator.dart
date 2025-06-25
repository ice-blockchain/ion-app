// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';

class IonPullToRefreshLoadingIndicator extends StatelessWidget {
  const IonPullToRefreshLoadingIndicator({
    required this.refreshState,
    required this.pulledExtent,
    required this.refreshTriggerPullDistance,
    super.key,
  });

  final RefreshIndicatorMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;

  @override
  Widget build(BuildContext context) {
    final percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0, 1);
    final shouldAnimate = [
      RefreshIndicatorMode.armed,
      RefreshIndicatorMode.refresh,
      RefreshIndicatorMode.done,
    ].contains(refreshState);
    final isRefreshing = [
      RefreshIndicatorMode.armed,
      RefreshIndicatorMode.refresh,
    ].contains(refreshState);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          top: 16.0.s,
          start: 0,
          end: 0,
          child: Opacity(
            opacity: isRefreshing ? 1 : percentageComplete,
            child: IONLoadingIndicatorThemed(
              value: shouldAnimate ? null : percentageComplete,
              size: Size.square(30.s),
            ),
          ),
        ),
      ],
    );
  }
}
