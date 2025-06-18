// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/twofa_initial_scaffold.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_phone_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class DeletePhoneInitialStep extends StatelessWidget {
  const DeletePhoneInitialStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return TwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: const IconAsset(Assets.svgIcon2faPhoneconfirm, size: 36),
      ),
      headerTitle: locale.phone_verification_title,
      prompt: Column(
        children: [
          const IconAsset(Assets.svgIcon2faPhoneVerification, size: 80),
          SizedBox(height: 16.0.s),
          const _LinkedPhone(),
          SizedBox(height: 24.0.s),
          const _EditPhoneButton(),
        ],
      ),
      buttonLabel: locale.button_delete,
      onButtonPressed: onNext,
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
    final obscuredPhone = linkedPhone != null ? obscurePhoneNumber(linkedPhone) : '';

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
          obscuredPhone,
          style: context.theme.appTextThemes.subtitle.copyWith(
            color: colors.primaryText,
          ),
        ),
      ],
    );
  }
}

class _EditPhoneButton extends StatelessWidget {
  const _EditPhoneButton();

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    return Button(
      type: ButtonType.outlined,
      label: Text(locale.two_fa_edit_phone_button),
      minimumSize: Size(0.0.s, 44.0.s),
      leadingIcon: const IconAsset(Assets.svgIconEditLink, size: 24),
      borderColor: colors.onTerararyFill,
      onPressed: () => PhoneEditRoute().push<void>(context),
    );
  }
}
