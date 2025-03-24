// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/stories/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/stories/providers/camera_actions_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/components.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/banuba_service.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

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
    final cameraActionsState = ref.watch(cameraActionsControllerProvider);
    final videoFile = cameraActionsState.whenOrNull(
      saved: (file) => MediaType.fromMimeType(file.mimeType ?? '') == MediaType.video ? file : null,
    );

    if (videoFile != null) {
      ref
        ..displayErrors(editMediaProvider(videoFile))
        ..listenSuccess(editMediaProvider(videoFile), (filePath) async {
          if (context.mounted && filePath != null) {
            await StoryPreviewRoute(
              path: filePath,
              mimeType: videoFile.mimeType,
            ).push<void>(context);
          }
        });
    }

    return PermissionAwareWidget(
      permissionType: Permission.camera,
      onGranted: () async => ref.read(cameraControllerNotifierProvider.notifier).resumeCamera(),
      requestDialog: const PermissionRequestSheet(
        permission: Permission.camera,
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
                  ready: (controller, _, __) => CustomCameraPreview(controller: controller),
                  orElse: () => const CenteredLoadingIndicator(),
                ),
                if (isRecording)
                  CameraRecordingIndicator(recordingDuration: recordingDuration)
                else
                  const CameraIdlePreview(),
                Positioned.fill(
                  bottom: 16.0.s,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CameraCaptureButton(
                      isRecording: isRecording,
                      recordingProgress: recordingProgress,
                      onCapturePhoto: isCameraReady
                          ? () async {
                              await ref.read(cameraActionsControllerProvider.notifier).takePhoto();

                              final selectedFile = ref
                                  .read(cameraActionsControllerProvider)
                                  .whenOrNull(saved: (file) => file);

                              if (selectedFile != null && context.mounted) {
                                await ref
                                    .read(
                                      imageProcessorNotifierProvider(ImageProcessingType.story)
                                          .notifier,
                                    )
                                    .process(
                                      assetId: selectedFile.path,
                                      cropUiSettings:
                                          ref.read(mediaServiceProvider).buildCropImageUiSettings(
                                        context,
                                        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
                                      ),
                                    );
                              }
                            }
                          : null,
                      onRecordingStart: isCameraReady
                          ? () async => ref
                              .read(cameraActionsControllerProvider.notifier)
                              .startVideoRecording()
                          : null,
                      onRecordingStop: isCameraReady
                          ? () async => ref
                              .read(cameraActionsControllerProvider.notifier)
                              .stopVideoRecording()
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
