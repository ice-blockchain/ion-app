// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_manager.c.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_state.c.dart';
import 'package:ion/app/features/ion_connect/providers/restore_device_keypair_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/upload_device_keypair_notifier.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

const _iconSize = 80.0;

class DeviceKeypairDialog extends HookConsumerWidget {
  const DeviceKeypairDialog({
    required this.state,
    super.key,
  });

  final DeviceKeypairState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        return () => ref.read(deviceKeypairDialogManagerProvider.notifier).reject();
      },
      [],
    );

    return switch (state) {
      DeviceKeypairState.needsUpload || DeviceKeypairState.uploadInProgress => _UploadDialog(
          isInProgress: state == DeviceKeypairState.uploadInProgress,
        ),
      DeviceKeypairState.needsRestore => const _RestoreDialog(),
      _ => throw StateError('Invalid state: $state'),
    };
  }
}

class _UploadDialog extends HookConsumerWidget {
  const _UploadDialog({
    required this.isInProgress,
  });

  final bool isInProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listenError(uploadDeviceKeypairNotifierProvider, (_) => context.pop())
      ..listenSuccess(uploadDeviceKeypairNotifierProvider, (_) => context.pop());

    return _DeviceKeypairDialogContent(
      icon: IconAsset(Assets.svgActionchatsynckey, size: _iconSize),
      title: isInProgress
          ? context.i18n.device_keypair_upload_complete_title
          : context.i18n.device_keypair_upload_title,
      description: isInProgress
          ? context.i18n.device_keypair_upload_incomplete_description
          : context.i18n.device_keypair_upload_description,
      actionButtonLabel: isInProgress
          ? context.i18n.device_keypair_button_complete_upload
          : context.i18n.device_keypair_button_upload_now,
      onActionButtonPressed: () async {
        await guardPasskeyDialog(
          context,
          (child) {
            return RiverpodUserActionSignerRequestBuilder(
              provider: uploadDeviceKeypairNotifierProvider,
              request: (signer) async {
                await ref
                    .read(uploadDeviceKeypairNotifierProvider.notifier)
                    .uploadDeviceKeypair(signer: signer);
              },
              child: child,
            );
          },
        );
      },
    );
  }
}

class _RestoreDialog extends HookConsumerWidget {
  const _RestoreDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listenError(restoreDeviceKeypairNotifierProvider, (_) => context.pop())
      ..listenSuccess(restoreDeviceKeypairNotifierProvider, (_) => context.pop());

    return _DeviceKeypairDialogContent(
      icon: IconAsset(Assets.svgActionchatrestorekey, size: _iconSize),
      title: context.i18n.device_keypair_restore_title,
      description: context.i18n.device_keypair_restore_description,
      actionButtonLabel: context.i18n.device_keypair_button_restore_now,
      onActionButtonPressed: () async {
        await guardPasskeyDialog(
          context,
          (child) {
            return RiverpodUserActionSignerRequestBuilder(
              provider: restoreDeviceKeypairNotifierProvider,
              request: (signer) async {
                await ref
                    .read(restoreDeviceKeypairNotifierProvider.notifier)
                    .restoreDeviceKeypair(signer: signer);
              },
              child: child,
            );
          },
        );
      },
    );
  }
}

class _DeviceKeypairDialogContent extends StatelessWidget {
  const _DeviceKeypairDialogContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionButtonLabel,
    required this.onActionButtonPressed,
  });

  final Widget icon;
  final String title;
  final String description;
  final String actionButtonLabel;
  final VoidCallback onActionButtonPressed;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            actions: const [
              NavigationCloseButton(),
            ],
          ),
          ScreenSideOffset.medium(
            child: Column(
              children: [
                icon,
                SizedBox(height: 8.0.s),
                Text(
                  title,
                  style: textStyles.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0.s),
                Text(
                  description,
                  style: textStyles.body2.copyWith(color: colors.secondaryText),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.0.s),
                Button(
                  minimumSize: Size(double.infinity, 56.0.s),
                  label: Text(actionButtonLabel),
                  onPressed: onActionButtonPressed,
                ),
              ],
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
