// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/providers/request_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/select_coin_modal_page.dart';
import 'package:ion/app/router/app_routes.c.dart';

class RequestCoinsModalPage extends ConsumerWidget {
  const RequestCoinsModalPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectCoinModalPage(
      onCoinSelected: (value) {
        ref.read(requestCoinsFormControllerProvider.notifier).setCoin(value);
        SelectNetworkProfileRoute(paymentType: PaymentType.request).push<void>(context);
      },
    );
  }
}
