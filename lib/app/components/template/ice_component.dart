// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/template_provider.r.dart';

abstract class IceComponent extends ConsumerWidget {
  const IceComponent({super.key});

  String get name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeName = _routeName(context);

    final templateConfig = ref.watch(templateConfigPageProvider(routeName));
    final config = templateConfig?.components?[name];

    if (config?.hidden ?? false) {
      return const SizedBox.shrink();
    } else {
      return buildComponent(context, ref, config?.variant ?? 0);
    }
  }

  Widget buildComponent(BuildContext context, WidgetRef ref, int variant);

  String _routeName(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) {
      return '';
    }
    return route.settings.name ?? '';
  }
}
