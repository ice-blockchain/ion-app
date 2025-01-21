// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_initial_scaffold.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_email_provider.c.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteEmailInitialStep extends StatelessWidget {
  const DeleteEmailInitialStep({required this.onButtonPressed, super.key});

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return DeleteTwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: Assets.svg.icon2faEmailauth.icon(size: 36.0.s),
      ),
      headerTitle: locale.email_verification_title,
      prompt: Column(
        children: [
          Assets.svg.icon2faEmailVerification.icon(size: 80.0.s),
          SizedBox(height: 16.0.s),
          const _LinkedEmail(),
          SizedBox(height: 24.0.s),
          const _EditEmailButton(),
        ],
      ),
      buttonLabel: locale.two_fa_delete_email_button,
      onButtonPressed: onButtonPressed,
    );
  }
}

class _LinkedEmail extends ConsumerWidget {
  const _LinkedEmail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    final linkedEmail = ref.watch(linkedEmailProvider).valueOrNull;
    final shortenedEmail = linkedEmail != null ? shortenEmail(linkedEmail) : '';

    return Column(
      children: [
        Text(
          locale.two_fa_account_linked_to,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        SizedBox(height: 8.0.s),
        Text(
          shortenedEmail,
          style: context.theme.appTextThemes.subtitle.copyWith(
            color: colors.primaryText,
          ),
        ),
      ],
    );
  }
}

class _EditEmailButton extends StatelessWidget {
  const _EditEmailButton();

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    return Button(
      type: ButtonType.outlined,
      label: Text(locale.two_fa_edit_email_button),
      minimumSize: Size(0.0.s, 44.0.s),
      leadingIcon: Assets.svg.iconEditLink.icon(size: 24.0.s),
      borderColor: colors.onTerararyFill,
      onPressed: () {},
    );
  }
}
