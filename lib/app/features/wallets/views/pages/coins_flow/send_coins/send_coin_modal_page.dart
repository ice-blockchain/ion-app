// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/select_coin_modal_page.dart';

class SendCoinModalPage extends ConsumerWidget {
  const SendCoinModalPage({
    required this.selectNetworkRouteLocationBuilder,
    super.key,
  });

  final String Function() selectNetworkRouteLocationBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectCoinModalPage(
      onCoinSelected: (value) {
        ref.read(sendAssetFormControllerProvider.notifier).setCoin(value);
        context.push(selectNetworkRouteLocationBuilder());
      },
    );
  }
}
