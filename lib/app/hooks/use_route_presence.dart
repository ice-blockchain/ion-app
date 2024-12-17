// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/hooks/use_on_init.dart';

/// A hook monitors the presence of the current route and triggers
/// callbacks when the route becomes active or inactive.
void useRoutePresence({
  void Function()? onBecameInactive,
  void Function()? onBecameActive,
}) {
  final context = useContext();
  final isRouteActive = context.isCurrentRoute;
  final wasRouteActive = usePrevious(isRouteActive);

  useOnInit(
    () {
      if ((wasRouteActive ?? false) && !isRouteActive) {
        onBecameInactive?.call();
      } else if (wasRouteActive == false && isRouteActive == true) {
        onBecameActive?.call();
      }
    },
    [isRouteActive, wasRouteActive],
  );
}
