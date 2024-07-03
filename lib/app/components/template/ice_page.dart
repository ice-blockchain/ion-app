import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IcePage extends HookConsumerWidget {
  const IcePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildPage(context, ref);
  }

  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  );
}
