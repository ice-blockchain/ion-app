// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/card/warning_card.dart';
import 'package:ion/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/step_pages.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class AuthenticatorDeletePage extends StatelessWidget {
  const AuthenticatorDeletePage(this.step, {super.key});

  final AuthenticatorDeleteSteps step;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: step.progressValue,
            title: step.getAppBarTitle(context),
            onClose: () => WalletRoute().go(context),
          ),
          SliverToBoxAdapter(
            child: AuthHeader(
              topOffset: 34.0.s,
              title: locale.authenticator_delete_title,
              description: locale.authenticator_delete_description,
              icon: AuthHeaderIcon(
                icon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SizedBox(height: 64.0.s),
                Expanded(
                  child: switch (step) {
                    AuthenticatorDeleteSteps.select => const AuthenticatorDeleteSelectOptionsPage(),
                    AuthenticatorDeleteSteps.input => Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final selectedTwoFaOptions = ref.watch(selectedTwoFaOptionsProvider);
                          return AuthenticatorDeleteInputPage(
                            twoFaTypes: selectedTwoFaOptions.toList(),
                          );
                        },
                      ),
                  },
                ),
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
