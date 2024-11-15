// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/features/protect_account/email/views/pages/setup_email/step_pages.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class EmailSetupPage extends ConsumerWidget {
  const EmailSetupPage(this.step, this.email, {super.key});

  final EmailSetupSteps step;
  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider) ?? '';
    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: step.progressValue,
            title: step.getAppBarTitle(context),
            onClose: () => ProfileRoute(pubkey: currentPubkey).go(context),
            showBackButton: step != EmailSetupSteps.success,
            showProgress: step != EmailSetupSteps.success,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                AuthHeader(
                  topOffset: 34.0.s,
                  title: step.getPageTitle(context),
                  description: step.getDescription(context),
                  titleStyle: context.theme.appTextThemes.headline2,
                  descriptionStyle: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                  icon: AuthHeaderIcon(
                    icon: Assets.svg.icon2faEmailauth.icon(size: 36.0.s),
                  ),
                ),
                Expanded(
                  child: switch (step) {
                    EmailSetupSteps.input => const EmailSetupInputPage(),
                    EmailSetupSteps.confirmation => EmailSetupConfirmPage(email: email!),
                    EmailSetupSteps.success => const EmailSetupSuccessPage(),
                  },
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
