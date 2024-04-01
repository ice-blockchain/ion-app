import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns memoized device bottom offset (bottom notch height)
///
/// Useful when we need to prevent bottom offset from changing
/// e.g. when keyboard is shown
double useMemoizedBottomOffset(BuildContext context) {
  return useMemoized(
    () => MediaQuery.of(context).padding.bottom,
    <Object?>[],
  );
}
