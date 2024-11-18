// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/core/providers/app_info_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/story_camera_state.dart';
import 'package:ion/app/features/feed/stories/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/stories/providers/story_camera_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/components.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_preview_page.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class StoryRecordPage extends HookConsumerWidget {
  const StoryRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraControllerNotifierProvider);

    final isRecording = cameraState.maybeWhen(
      ready: (_, isRecording, __) => isRecording,
      orElse: () => false,
    );

    final (recordingDuration, recordingProgress) = useRecordingProgress(
      ref,
      isRecording: isRecording,
    );

    final isCameraReady = cameraState is CameraReady;

    ref.listen<StoryCameraState>(storyCameraControllerProvider, (_, next) {
      if (next is StoryCameraSaved && context.mounted) {
        StoryPreviewRoute(
          path: next.videoPath,
          storyType: StoryType.video,
        ).push<void>(context);
      }
    });

    return PermissionAwareWidget(
      permissionType: Permission.camera,
      onGranted: () async => ref.read(cameraControllerNotifierProvider.notifier).resumeCamera(),
      requestDialog: PermissionRequestSheet.fromType(
        context,
        permissionType: Permission.camera,
        appName: ref.watch(appInfoProvider).valueOrNull?.appName ?? '',
      ),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.theme.appColors.primaryText,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                cameraState.maybeWhen(
                  ready: (controller, _, __) => StoryCameraPreview(controller: controller),
                  orElse: () => const CenteredLoadingIndicator(),
                ),
                if (isRecording)
                  StoryRecordingIndicator(recordingDuration: recordingDuration)
                else
                  const IdleCameraPreview(),
                Positioned.fill(
                  bottom: 16.0.s,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: StoryCaptureButton(
                      isRecording: isRecording,
                      recordingProgress: recordingProgress,
                      onRecordingStart: isCameraReady
                          ? () async =>
                              ref.read(storyCameraControllerProvider.notifier).startVideoRecording()
                          : null,
                      onRecordingStop: isCameraReady
                          ? () async =>
                              ref.read(storyCameraControllerProvider.notifier).stopVideoRecording()
                          : null,
                    ),
                  ),
                ),
                ScreenBottomOffset(margin: 42.0.s),
              ],
            ),
          ),
        );
      },
    );
  }
}
