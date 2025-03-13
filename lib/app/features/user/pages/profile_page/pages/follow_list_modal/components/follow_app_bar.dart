// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class FollowAppBar extends StatelessWidget {
  const FollowAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: false,
      flexibleSpace: NavigationAppBar.modal(
        actions: [
          NavigationCloseButton(
            onPressed: () => context.pop(),
          ),
        ],
        showBackButton: false,
        title: Text(title),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: NavigationAppBar.modalHeaderHeight,
      pinned: true,
    );
  }
}
