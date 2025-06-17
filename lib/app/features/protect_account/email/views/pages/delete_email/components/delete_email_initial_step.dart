// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/twofa_initial_scaffold.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_email_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteEmailInitialStep extends StatelessWidget {
  const DeleteEmailInitialStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return TwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: IconAsset(Assets.svgIcon2faEmailauth, size: 36.0),
      ),
      headerTitle: locale.email_verification_title,
      prompt: Column(
        children: [
          IconAsset(Assets.svgIcon2faEmailVerification, size: 80.0),
          SizedBox(height: 16.0.s),
          const _LinkedEmail(),
          SizedBox(height: 24.0.s),
          const _EditEmailButton(),
        ],
      ),
      buttonLabel: locale.two_fa_delete_email_button,
      onButtonPressed: onNext,
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
    final obscuredEmail = linkedEmail != null ? obscureEmail(linkedEmail) : '';

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
          obscuredEmail,
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
      label: Text(locale.two_fa_edit_email_title),
      minimumSize: Size(0.0.s, 44.0.s),
      leadingIcon: IconAsset(Assets.svgIconEditLink, size: 24.0),
      borderColor: colors.onTerararyFill,
      onPressed: () => EmailEditRoute().push<void>(context),
    );
  }
}
