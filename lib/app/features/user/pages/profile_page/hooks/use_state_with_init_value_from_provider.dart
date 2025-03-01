// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

ValueNotifier<T?> useSateWithInitValueFromProvider<T>(
  WidgetRef ref,
  ProviderListenable<AsyncValue<T>> provider,
) {
  final initialValue = ref.watch(provider).valueOrNull;
  final notifier = useState<T?>(null);
  useEffect(
    () {
      if (notifier.value == null && initialValue != null) {
        notifier.value = initialValue;
      }
      return null;
    },
    [initialValue],
  );
  return notifier;
}
