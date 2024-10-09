// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/protect_account/backup/providers/create_recovery_creds_action_notifier.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_save/recovery_keys_save_error_state.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_save/recovery_keys_save_loading_state.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_save/recovery_keys_save_success_state.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class CreateRecoveryKeyPage extends StatelessWidget {
  const CreateRecoveryKeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SheetContent(
      body: Column(
        children: [
          _NavBar(),
          _Header(),
          _Body(),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.modal(
      actions: [
        NavigationCloseButton(
          onPressed: () => WalletRoute().go(context),
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

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recoveryData = ref.watch(createRecoveryCredsActionNotifierProvider);

    if (recoveryData.isLoading) {
      return const RecoveryKeysSaveLoadingState();
    }
    if (recoveryData.hasError) {
      return const RecoveryKeysSaveErrorState();
    }
    if (recoveryData.hasValue) {
      return RecoveryKeysSaveSuccessState(recoveryData: recoveryData.requireValue!);
    }

    return const RecoveryKeysSaveLoadingState();
  }
}
