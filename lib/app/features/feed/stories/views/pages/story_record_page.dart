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
import 'package:ion/app/features/feed/stories/data/models/camera_capture_state.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/stories/providers/camera_capture_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/media_editing_service.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/camera_idle_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/custom_camera_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_capture_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_recording_indicator.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class StoryRecordPage extends HookConsumerWidget {
  const StoryRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraControllerNotifierProvider);
    final isRecording = cameraState.maybeWhen(
      ready: (_, recording, __, ___, ____, _____) => recording,
      orElse: () => false,
    );

    final (recordingDuration, recordingProgress) =
        useRecordingProgress(ref, isRecording: isRecording);

    final isCameraReady = cameraState is CameraReady;
    final captureController = ref.watch(cameraCaptureControllerProvider.notifier);

    ref
      ..listen<CameraCaptureState>(
        cameraCaptureControllerProvider,
        (previous, next) => _handleCameraCaptureState(context, ref, next),
      )
      ..listen<ImageProcessorState>(
        imageProcessorNotifierProvider(ImageProcessingType.story),
        (previous, next) => _handleImageProcessorState(context, ref, next),
      );

    Future<void> onGallerySelected(MediaFile file) => _handleGallerySelection(context, ref, file);

    return PermissionAwareWidget(
      permissionType: Permission.camera,
      onGranted: () => ref.read(cameraControllerNotifierProvider.notifier).resumeCamera(),
      requestDialog: const PermissionRequestSheet(permission: Permission.camera),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
      builder: (context, _) => Scaffold(
        backgroundColor: context.theme.appColors.primaryText,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              cameraState.maybeWhen(
                ready: (controller, _, __, ___, ____, _____) =>
                    CustomCameraPreview(controller: controller),
                orElse: () => const CenteredLoadingIndicator(),
              ),
              if (isRecording)
                CameraRecordingIndicator(recordingDuration: recordingDuration)
              else
                cameraState.maybeWhen(
                  ready: (
                    _,
                    __,
                    ___,
                    minZoomLevel,
                    maxZoomLevel,
                    currentZoomLevel,
                  ) =>
                      CameraIdlePreview(
                    onGallerySelected: onGallerySelected,
                    minZoomLevel: minZoomLevel,
                    maxZoomLevel: maxZoomLevel,
                    currentZoomLevel: currentZoomLevel,
                    onZoomChanged: (zoom) =>
                        ref.read(cameraControllerNotifierProvider.notifier).setZoomLevel(zoom),
                  ),
                  orElse: () => CameraIdlePreview(
                    onGallerySelected: onGallerySelected,
                  ),
                ),
              Positioned.fill(
                bottom: 16.0.s,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CameraCaptureButton(
                    isRecording: isRecording,
                    recordingProgress: recordingProgress,
                    onCapturePhoto: isCameraReady ? captureController.takePhoto : null,
                    onRecordingStart: isCameraReady ? captureController.startVideoRecording : null,
                    onRecordingStop: isCameraReady ? captureController.stopVideoRecording : null,
                  ),
                ),
              ),
              ScreenBottomOffset(margin: 42.0.s),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCameraCaptureState(
    BuildContext context,
    WidgetRef ref,
    CameraCaptureState state,
  ) async {
    await state.whenOrNull(
      saved: (file) async {
        final mediaType = MediaType.fromMimeType(file.mimeType ?? '');

        if (mediaType == MediaType.video) {
          final edited =
              await ref.read(mediaEditingServiceProvider).edit(file, resumeCamera: false);

          if (edited != null && edited != file.path && context.mounted) {
            await StoryPreviewRoute(path: edited, mimeType: file.mimeType).push<void>(context);
          }
          await ref.read(cameraControllerNotifierProvider.notifier).resumeCamera();
        } else if (mediaType == MediaType.image) {
          await ref
              .read(
                imageProcessorNotifierProvider(ImageProcessingType.story).notifier,
              )
              .process(
                assetId: file.path,
                cropUiSettings: ref.read(mediaServiceProvider).buildCropImageUiSettings(
                  context,
                  aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
                ),
              );
        }
      },
    );
  }

  Future<void> _handleImageProcessorState(
    BuildContext context,
    WidgetRef ref,
    ImageProcessorState state,
  ) async {
    await state.whenOrNull(
      processed: (file) async {
        final edited = await ref
            .read(mediaEditingServiceProvider)
            .editExternalPhoto(file.path, resumeCamera: false);

        if (edited != null && edited != file.path && context.mounted) {
          await StoryPreviewRoute(path: edited, mimeType: file.mimeType).push<void>(context);
        }
        await ref.read(cameraControllerNotifierProvider.notifier).resumeCamera();
      },
    );
  }

  Future<void> _handleGallerySelection(
    BuildContext context,
    WidgetRef ref,
    MediaFile file,
  ) async {
    final mediaType = MediaType.fromMimeType(file.mimeType ?? '');

    if (mediaType == MediaType.video) {
      final edited = await ref.read(mediaEditingServiceProvider).edit(file, resumeCamera: false);

      if (edited != null && edited != file.path && context.mounted) {
        await StoryPreviewRoute(path: edited, mimeType: file.mimeType).push<void>(context);
      }
      await ref.read(cameraControllerNotifierProvider.notifier).resumeCamera();
    } else if (mediaType == MediaType.image) {
      await ref
          .read(
            imageProcessorNotifierProvider(ImageProcessingType.story).notifier,
          )
          .process(
            assetId: file.path,
            cropUiSettings: ref.read(mediaServiceProvider).buildCropImageUiSettings(
              context,
              aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            ),
          );
    }
  }
}
