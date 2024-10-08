// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/components/recovery_keys_input_container/recovery_keys_input_container.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_client.dart';

class RestoreRecoveryKeysPage extends HookConsumerWidget {
  const RestoreRecoveryKeysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider.future);

    final recoverUserResult = useState<RecoverUserResult?>(null);

    if (recoverUserResult.value == null) {
      return FutureBuilder<IonApiClient>(
        future: ionClient,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final ionClient = snapshot.data!;

          return RecoveryKeysInputContainer(
            validator: (value, property) => value == null || value.isEmpty ? '' : null,
            onContinuePressed: (name, id, code) async {
              recoverUserResult.value = await ionClient(username: name)
                  .auth
                  .recoverUser(credentialId: id, recoveryKey: code);
            },
          );
        },
      );
    }

    // TODO: add failure UI state

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.backup_option_with_recovery_keys_title,
        icon: Assets.svg.iconLoginRestorekey.icon(size: 36.0.s),
        titleStyle: context.theme.appTextThemes.headline2,
        descriptionStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
        children: [
          const Spacer(),
          ScreenSideOffset.small(
            child: InfoCard(
              iconAsset: Assets.svg.actionWalletSuccess2Fa,
              title: context.i18n.common_congratulations,
              description: context.i18n.two_fa_success_desc,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
