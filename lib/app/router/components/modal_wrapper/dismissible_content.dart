// SPDX-License-Identifier: ice License 1.0

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DismissibleContent extends StatelessWidget {
  const DismissibleContent({
    required this.child,
    required this.state,
    super.key,
  });

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => context.pop(),
      direction: DismissiblePageDismissDirection.multi,
      child: child,
    );
  }
}
