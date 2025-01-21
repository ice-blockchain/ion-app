// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_initial_scaffold.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_phone_provider.c.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class DeletePhoneInitialStep extends StatelessWidget {
  const DeletePhoneInitialStep({required this.onButtonPressed, super.key});

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return DeleteTwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: Assets.svg.icon2faPhoneconfirm.icon(size: 36.0.s),
      ),
      headerTitle: locale.phone_verification_title,
      prompt: Column(
        children: [
          Assets.svg.icon2faPhoneVerification.icon(size: 80.0.s),
          SizedBox(height: 16.0.s),
          const _LinkedPhone(),
        ],
      ),
      buttonLabel: locale.button_delete,
      onButtonPressed: onButtonPressed,
    );
  }
}

class _LinkedPhone extends ConsumerWidget {
  const _LinkedPhone();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    final linkedPhone = ref.watch(linkedPhoneProvider).valueOrNull;
    final shortenedPhone = linkedPhone != null ? shortenPhoneNumber(linkedPhone) : '';

    return Column(
      children: [
        Text(
          locale.two_fa_account_linked_to,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        SizedBox(height: 8.0.s),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shortenedPhone,
              style: context.theme.appTextThemes.subtitle.copyWith(
                color: colors.primaryText,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Assets.svg.iconEditLink.icon(
                size: 24.0.s,
                color: colors.primaryAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
