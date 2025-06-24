// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ImportTokenActionButton extends ConsumerWidget {
  const ImportTokenActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;

    return GestureDetector(
      onTap: () async {
        final notifier = ref.read(manageCoinsNotifierProvider.notifier)..disableSave();
        await ImportTokenRoute().push<void>(context);
        notifier.enableSave();
      },
      child: Assets.svg.iconPlusCreatechannel.icon(
        color: colors.primaryAccent,
        size: 33.0.s,
      ),
    );
  }
}
