import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/progress_bar/app_progress_bar.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_steps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

import 'step_pages.dart';

class AuthenticatorDeletePage extends StatelessWidget {
  const AuthenticatorDeletePage(this.step, {super.key});

  final AuthenticatorDeleteSteps step;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: true,
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
            title: Text(step.getAppBarTitle(context)),
          ),
          AppProgressIndicator(progressValue: step.progressValue),
          AuthHeader(
            topOffset: 34.0.s,
            title: locale.authenticator_delete_title,
            description: locale.authenticator_delete_description,
            titleStyle: context.theme.appTextThemes.headline2,
            descriptionStyle: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
            icon: AuthHeaderIcon(
              icon: Assets.images.icons.iconWalletProtectFill.icon(size: 36.0.s),
            ),
          ),
          Expanded(
            child: switch (step) {
              AuthenticatorDeleteSteps.select => AuthenticatorDeleteSelectOptionsPage(),
              AuthenticatorDeleteSteps.input => AuthenticatorDeleteInputPage(),
            },
          ),
          SizedBox(height: 22.0.s),
          ScreenSideOffset.large(
            child: RoundedCard.outlined(
              padding: EdgeInsets.symmetric(horizontal: 10.0.s),
              child: ListItem(
                contentPadding: EdgeInsets.zero,
                // backgroundColor: context.theme.appColors.secondaryBackground,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0.s),
                ),
                leading: Assets.images.icons.iconReport.icon(
                  size: 20.0.s,
                  color: context.theme.appColors.attentionRed,
                ),
                title: Text(
                  locale.two_fa_warning,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.attentionRed,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
