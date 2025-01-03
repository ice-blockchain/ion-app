// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class DeleteTwoFAStepScaffold extends ConsumerWidget {
  const DeleteTwoFAStepScaffold({
    required this.headerTitle,
    required this.headerDescription,
    required this.headerIcon,
    required this.child,
    this.contentPadding,
    super.key,
  });

  final String headerTitle;
  final String headerDescription;
  final Widget headerIcon;
  final Widget child;
  final double? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          AppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              actions: const [
                NavigationCloseButton(),
              ],
            ),
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            automaticallyImplyLeading: false,
          ),
          AuthHeader(
            title: headerTitle,
            description: headerDescription,
            icon: AuthHeaderIcon(icon: headerIcon),
          ),
          SizedBox(height: contentPadding ?? 64.0.s),
          Expanded(child: child),
        ],
      ),
    );
  }
}
