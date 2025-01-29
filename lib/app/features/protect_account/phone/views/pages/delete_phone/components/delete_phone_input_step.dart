// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class DeletePhoneInputStep extends ConsumerWidget {
  const DeletePhoneInputStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return const SizedBox();
    // return TwoFAStepScaffold(
    //   headerTitle: locale.two_fa_deleting_phone_title,
    //   headerDescription: locale.two_fa_deleting_phone_description,
    //   headerIcon: Assets.svg.icon2faPhoneconfirm.icon(size: 36.0.s),
    //   child: TwoFAInputStep(
    //     modifiedTwoFa: TwoFaType.sms,
    //     onDeleteSuccess: () => PhoneDeleteSuccessRoute().push<void>(context),
    //     twoFaTypes: ref.watch(selectedTwoFaOptionsProvider).toList(),
    //   ),
    // );
  }
}
