import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useOnInit(
  void Function() callback, [
  List<Object?> keys = const [],
]) {
  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => callback(),
      );
      return null;
    },
    keys,
  );
}
