// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
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
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class DeviceKeypairDialog extends HookConsumerWidget {
  const DeviceKeypairDialog({
    required this.state,
    super.key,
  });

  final DeviceKeypairState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: switch (state) {
        DeviceKeypairState.needsUpload || DeviceKeypairState.uploadInProgress => _UploadDialog(
            isInProgress: state == DeviceKeypairState.uploadInProgress,
          ),
        DeviceKeypairState.needsRestore => const _RestoreDialog(),
        _ => throw StateError('Invalid state: $state'),
      },
    );
  }
}

class _UploadDialog extends HookConsumerWidget {
  const _UploadDialog({
    required this.isInProgress,
  });

  final bool isInProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    ref
      ..listenError(uploadDeviceKeypairNotifierProvider, (_) => context.pop())
      ..listenSuccess(uploadDeviceKeypairNotifierProvider, (_) => context.pop());

    return ScreenSideOffset.medium(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 48.0.s),
          Text(
            isInProgress
                ? context.i18n.device_keypair_upload_complete_title
                : context.i18n.device_keypair_upload_title,
            style: textStyles.title,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0.s),
          Text(
            isInProgress
                ? context.i18n.device_keypair_upload_incomplete_description
                : context.i18n.device_keypair_upload_description,
            style: textStyles.body2.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.0.s),
          Button(
            minimumSize: Size(double.infinity, 56.0.s),
            label: Text(
              isInProgress
                  ? context.i18n.device_keypair_button_complete_upload
                  : context.i18n.device_keypair_button_upload_now,
            ),
            onPressed: () async {
              await guardPasskeyDialog(
                context,
                (child) => RiverpodUserActionSignerRequestBuilder(
                  provider: uploadDeviceKeypairNotifierProvider,
                  request: (signer) async {
                    await ref
                        .read(uploadDeviceKeypairNotifierProvider.notifier)
                        .uploadDeviceKeypair(signer: signer);
                  },
                  child: child,
                ),
              );
            },
          ),
          SizedBox(height: 12.0.s),
          Button(
            type: ButtonType.secondary,
            minimumSize: Size(double.infinity, 56.0.s),
            label: Text(context.i18n.device_keypair_button_not_now),
            onPressed: () {
              ref.read(deviceKeypairDialogManagerProvider.notifier).rejectUpload();
              Navigator.of(context).pop();
            },
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}

class _RestoreDialog extends HookConsumerWidget {
  const _RestoreDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    ref
      ..listenError(restoreDeviceKeypairNotifierProvider, (_) => context.pop())
      ..listenSuccess(restoreDeviceKeypairNotifierProvider, (_) => context.pop());

    return ScreenSideOffset.medium(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 48.0.s),
          Text(
            context.i18n.device_keypair_restore_title,
            style: textStyles.title,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0.s),
          Text(
            context.i18n.device_keypair_restore_description,
            style: textStyles.body2.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.0.s),
          Button(
            minimumSize: Size(double.infinity, 56.0.s),
            label: Text(context.i18n.device_keypair_button_restore_now),
            onPressed: () async {
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
          ),
          SizedBox(height: 12.0.s),
          Button(
            type: ButtonType.secondary,
            minimumSize: Size(double.infinity, 56.0.s),
            label: Text(context.i18n.device_keypair_button_not_now),
            onPressed: () {
              ref.read(deviceKeypairDialogManagerProvider.notifier).rejectRestore();
              Navigator.of(context).pop();
            },
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
