// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_input_step.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_step_scaffold.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAuthenticatorInputStep extends ConsumerWidget {
  const DeleteAuthenticatorInputStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return DeleteTwoFAStepScaffold(
      headerTitle: locale.authenticator_delete_title,
      headerDescription: locale.authenticator_delete_description,
      headerIcon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
      contentPadding: 8.0.s,
      child: DeleteTwoFAInputStep(
        twoFaToDelete: TwoFaType.auth,
        onDeleteSuccess: () => AuthenticatorDeleteSuccessRoute().push<void>(context),
        twoFaTypes: ref.watch(selectedTwoFaOptionsProvider).toList(),
      ),
    );
  }
}
