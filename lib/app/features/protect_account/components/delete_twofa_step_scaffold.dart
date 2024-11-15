// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/card/warning_card.dart';
import 'package:ion/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class DeleteTwoFAStepScaffold extends ConsumerWidget {
  const DeleteTwoFAStepScaffold({
    required this.child,
    required this.progressValue,
    required this.title,
    required this.headerTitle,
    required this.headerDescription,
    required this.headerIcon,
    super.key,
  });

  final double progressValue;
  final String title;
  final String headerTitle;
  final String headerDescription;
  final Widget headerIcon;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final currentPubkey = ref.watch(currentPubkeySelectorProvider) ?? '';

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: progressValue,
            title: title,
            onClose: () => ProfileRoute(pubkey: currentPubkey).go(context),
          ),
          SliverToBoxAdapter(
            child: AuthHeader(
              topOffset: 34.0.s,
              title: headerTitle,
              description: headerDescription,
              icon: AuthHeaderIcon(icon: headerIcon),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SizedBox(height: 64.0.s),
                Expanded(child: child),
                SizedBox(height: 64.0.s),
                ScreenSideOffset.large(
                  child: WarningCard(
                    text: locale.two_fa_warning,
                  ),
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
