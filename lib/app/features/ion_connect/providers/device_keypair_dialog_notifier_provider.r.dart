// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_manager.r.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_state.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_keypair_dialog_notifier_provider.r.g.dart';

@riverpod
class DeviceKeypairDialogNotifier extends _$DeviceKeypairDialogNotifier {
  @override
  bool build() {
    onLogout(ref, () {
      state = false;
    });

    return false;
  }

  /// Gets the current state that determines if a dialog should be shown
  Future<DeviceKeypairState?> getDialogState() async {
    if (state) return null; // Already shown this session

    final dialogManager = ref.read(deviceKeypairDialogManagerProvider.notifier);
    final currentState = await dialogManager.getCurrentState();

    switch (currentState) {
      case DeviceKeypairState.needsUpload:
      case DeviceKeypairState.uploadInProgress:
      case DeviceKeypairState.needsRestore:
        return currentState;
      case DeviceKeypairState.completed:
      case DeviceKeypairState.rejectedThisSession:
        return null;
    }
  }

  /// Marks that a dialog has been shown this session
  void markDialogShown() {
    state = true;
  }

  /// Resets the dialog shown state (for testing or when user logs out)
  void reset() {
    state = false;
  }
}
