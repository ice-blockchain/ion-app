// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ice/app/features/protect_account/phone/views/pages/setup_phone/step_pages.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class PhoneSetupPage extends StatelessWidget {
  const PhoneSetupPage(this.step, this.phone, {super.key});

  final PhoneSetupSteps step;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: step.progressValue,
            title: step.getAppBarTitle(context),
            onClose: () => WalletRoute().go(context),
            showBackButton: step != PhoneSetupSteps.success,
            showProgress: step != PhoneSetupSteps.success,
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
                    PhoneSetupSteps.input => const PhoneSetupInputPage(),
                    PhoneSetupSteps.confirmation => PhoneSetupConfirmPage(phone: phone!),
                    PhoneSetupSteps.success => const PhoneSetupSuccessPage(),
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
