// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/setup_phone/step_pages.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class PhoneSetupPage extends ConsumerWidget {
  const PhoneSetupPage(this.step, this.phone, {super.key});

  final PhoneSetupSteps step;
  final String? phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: step == PhoneSetupSteps.success
          ? Padding(
              padding: EdgeInsets.only(top: 45.0.s, bottom: 16.0.s),
              child: const PhoneSetupSuccessPage(),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  primary: false,
                  flexibleSpace: NavigationAppBar.modal(
                    showBackButton: step != PhoneSetupSteps.success,
                    actions: [
                      NavigationCloseButton(
                        onPressed: Navigator.of(context, rootNavigator: true).pop,
                      ),
                    ],
                  ),
                  toolbarHeight: NavigationAppBar.modalHeaderHeight,
                  automaticallyImplyLeading: false,
                  pinned: true,
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
                          icon: Assets.svg.icon2faPhoneconfirm.icon(size: 36.0.s),
                        ),
                      ),
                      if (step == PhoneSetupSteps.input)
                        const Expanded(
                          child: PhoneSetupInputPage(),
                        ),
                      if (step == PhoneSetupSteps.confirmation)
                        Expanded(
                          child: PhoneSetupConfirmPage(phone: phone!),
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
