// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/providers/force_update_provider.c.dart';

bool useAppUpdate(WidgetRef ref) {
  final isModalShown = useState(false);
  final forceUpdateState = ref.watch(forceUpdateProvider);

  useEffect(
    () {
      if (forceUpdateState.shouldShowUpdateModal && !isModalShown.value) {
        isModalShown.value = true;
      } else if (!forceUpdateState.shouldShowUpdateModal && isModalShown.value) {
        isModalShown.value = false;
      }
      return null;
    },
    [forceUpdateState],
  );

  return isModalShown.value;
}
