// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/backup/providers/create_recovery_key_action_notifier.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/create_recover_key_page/components/create_recovery_key_error_state.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/create_recover_key_page/components/create_recovery_key_loading_state.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/create_recover_key_page/components/create_recovery_key_success_state.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateRecoveryKeyPage extends StatelessWidget {
  const CreateRecoveryKeyPage({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        children: [
          _NavBar(pubkey: pubkey),
          const _Header(),
          _Body(pubkey: pubkey),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.modal(
      actions: [
        NavigationCloseButton(
          onPressed: () => ProfileRoute(pubkey: pubkey).go(context),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.s),
      child: AuthHeader(
        topOffset: 0.0.s,
        title: locale.backup_option_with_recovery_keys_title,
        description: locale.backup_option_with_recovery_keys_description,
        titleStyle: context.theme.appTextThemes.headline2,
        descriptionStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
        icon: AuthHeaderIcon(
          icon: Assets.svg.iconLoginRestorekey.icon(size: 36.0.s),
        ),
      ),
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoveryData = ref.watch(createRecoveryKeyActionNotifierProvider);

    useOnInit(() {
      ref.read(createRecoveryKeyActionNotifierProvider.notifier).createRecoveryCredentials();
    });

    if (recoveryData.isLoading || recoveryData.valueOrNull == null) {
      return const CreateRecoveryKeyLoadingState();
    }
    if (recoveryData.hasError) {
      return const CreateRecoveryKeyErrorState();
    }
    if (recoveryData.hasValue) {
      return CreateRecoveryKeySuccessState(
        pubkey: pubkey,
        recoveryData: recoveryData.requireValue!,
      );
    }

    return const CreateRecoveryKeyLoadingState();
  }
}
