// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/bool.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/hooks/use_on_init.dart';

/// A hook monitors the presence of the current route and triggers
/// callbacks when the route becomes active or inactive.
void useRoutePresence({
  void Function()? onBecameInactive,
  void Function()? onBecameActive,
}) {
  final context = useContext();
  final router = GoRouter.maybeOf(context);
  if (router == null) {
    return;
  }
  final state = router.state;
  final fullPath = useState(state.fullPath);
  final fullPathRef = useRef(state.fullPath);
  final isActive = fullPathRef.value == fullPath.value && context.isCurrentRoute;
  final wasActive = usePrevious(isActive);

  useEffect(
    () {
      void listener() {
        fullPath.value = router.state.fullPath;
      }

      router.routerDelegate.addListener(listener);
      return () {
        router.routerDelegate.removeListener(listener);
      };
    },
    [router],
  );

  useOnInit(
    () {
      if (wasActive.falseOrValue && !isActive) {
        onBecameInactive?.call();
      } else if (wasActive == false && isActive) {
        onBecameActive?.call();
      }
    },
    [wasActive, isActive],
  );
}
