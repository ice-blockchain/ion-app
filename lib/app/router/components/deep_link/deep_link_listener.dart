// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/services/deep_link/deep_link_service.r.dart';

class DeepLinkListener extends HookConsumerWidget {
  const DeepLinkListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(
      () async {
        await ref
            .read(deepLinkServiceProvider)
            .init(onDeeplink: (path) => GoRouter.of(rootNavigatorKey.currentContext!).go(path));
      },
    );
    return child;
  }
}
