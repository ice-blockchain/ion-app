// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/stories/providers/story_camera_provider.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_picker_notifier.freezed.dart';
part 'avatar_picker_notifier.g.dart';

@freezed
sealed class AvatarPickerState with _$AvatarPickerState {
  const factory AvatarPickerState.initial() = AvatarPickerStateInitial;

  const factory AvatarPickerState.picked({required MediaFile file}) = AvatarPickerStatePicked;

  const factory AvatarPickerState.compressed({required MediaFile file}) =
      AvatarPickerStateCompressed;

  const factory AvatarPickerState.error({required String message}) = AvatarPickerStateError;
}

@Riverpod()
class AvatarPickerNotifier extends _$AvatarPickerNotifier {
  @override
  AvatarPickerState build() {
    return const AvatarPickerState.initial();
  }

  Future<void> pick({
    required CropImageUiSettings cropUiSettings,
    required Future<MediaFile?> Function() pickMediaFile,
  }) async {
    final mediaService = ref.read(mediaServiceProvider);
    final compressService = ref.read(mediaCompressServiceProvider);

    try {
      final mediaFile = await pickMediaFile();
      if (mediaFile == null) return;
      final cameraImagePath = await ref.read(assetFilePathProvider(mediaFile.path).future);
      if (cameraImagePath == null) return;
      final croppedImage = await mediaService.cropImage(
        uiSettings: cropUiSettings,
        path: cameraImagePath,
      );
      if (croppedImage == null) return;
      state = AvatarPickerState.picked(file: croppedImage);
      final compressedImage = await compressService.compressImage(
        croppedImage,
        width: 720,
        height: 720,
        quality: 70,
      );
      state = AvatarPickerState.compressed(file: compressedImage);
    } catch (error) {
      state = AvatarPickerState.error(message: error.toString());
    }
  }
}
