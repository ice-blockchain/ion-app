// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class DeleteAuthenticatorInputStep extends ConsumerWidget {
  const DeleteAuthenticatorInputStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return const SizedBox();
    // return TwoFAStepScaffold(
    //   headerTitle: locale.authenticator_delete_title,
    //   headerDescription: locale.authenticator_delete_description,
    //   headerIcon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
    //   contentPadding: 8.0.s,
    //   child: TwoFAInputStep(
    //     modifiedTwoFa: TwoFaType.auth,
    //     onDeleteSuccess: () => AuthenticatorDeleteSuccessRoute().push<void>(context),
    //     twoFaTypes: ref.watch(selectedTwoFaOptionsProvider).toList(),
    //   ),
    // );
  }
}
