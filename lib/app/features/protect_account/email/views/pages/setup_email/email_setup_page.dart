// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/features/protect_account/email/views/pages/setup_email/step_pages.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class EmailSetupPage extends StatelessWidget {
  const EmailSetupPage({
    required this.pubkey,
    required this.step,
    required this.email,
    super.key,
  });

  final String pubkey;
  final EmailSetupSteps step;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: step.progressValue,
            title: step.getAppBarTitle(context),
            onClose: () => ProfileRoute(pubkey: pubkey).go(context),
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
                    EmailSetupSteps.input => EmailSetupInputPage(pubkey: pubkey),
                    EmailSetupSteps.confirmation =>
                      EmailSetupConfirmPage(pubkey: pubkey, email: email!),
                    EmailSetupSteps.success => EmailSetupSuccessPage(pubkey: pubkey),
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
