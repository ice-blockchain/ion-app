// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Might be used to avoid state mutation in notifier methods after the provider is disposed.
///
/// Useful in cases when we need to skip the state mutations that are happening in
/// a notifier methods after the provider is disposed due to `watch`-ed dependencies are changed.
///
/// Example:
/// ```
/// @riverpod
/// class MyProvider extends _$MyProvider with NotifierMounted {
///     @override
///     State? build() {
///       ref.watch(someOtherProvider);
///       mount(ref);
///     }
///
///     Future<void> longRunningMethod() async {
///       final key = mountedKey;
///       final res = await longFetch();
///       if (mounted(key)) {
///         state = res;
///       }
///     }
/// }
/// ```
///
/// https://github.com/rrousselGit/riverpod/issues/1879#issuecomment-1433225149
mixin NotifierMounted {
  late Object? mountedKey;

  bool mounted(Object? key) => key == mountedKey;

  void mount(Ref ref) {
    mountedKey = Object();
    ref.onDispose(() => mountedKey = null);
  }
}
