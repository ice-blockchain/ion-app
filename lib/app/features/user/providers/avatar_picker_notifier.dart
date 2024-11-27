// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_picker_notifier.freezed.dart';
part 'avatar_picker_notifier.g.dart';

@freezed
sealed class AvatarPickerState with _$AvatarPickerState {
  const factory AvatarPickerState.initial() = AvatarPickerStateInitial;

  const factory AvatarPickerState.picked({required MediaFile file}) = AvatarPickerStatePicked;

  const factory AvatarPickerState.cropped({required MediaFile file}) = AvatarPickerStateCropped;

  const factory AvatarPickerState.processed({required MediaFile file}) = AvatarPickerStateProcessed;

  const factory AvatarPickerState.error({required String message}) = AvatarPickerStateError;
}

@riverpod
class AvatarPickerNotifier extends _$AvatarPickerNotifier {
  @override
  AvatarPickerState build() {
    return const AvatarPickerState.initial();
  }

  Future<void> process({
    required String assetId,
    required CropImageUiSettings cropUiSettings,
  }) async {
    final mediaService = ref.read(mediaServiceProvider);
    final compressService = ref.read(mediaCompressServiceProvider);

    try {
      state = const AvatarPickerState.initial();
      final assetImagePath = await ref.read(assetFilePathProvider(assetId).future);
      if (assetImagePath == null) {
        throw AssetEntityFileNotFoundException();
      }
      state = AvatarPickerState.picked(file: MediaFile(path: assetImagePath));
      final croppedImage = await mediaService.cropImage(
        uiSettings: cropUiSettings,
        path: assetImagePath,
      );
      if (croppedImage == null) {
        state = const AvatarPickerState.initial();
        return;
      }
      state = AvatarPickerState.cropped(file: croppedImage);
      final compressedImage = await compressService.compressImage(
        croppedImage,
        width: 720,
        height: 720,
        quality: 70,
      );
      state = AvatarPickerState.processed(file: compressedImage);
    } catch (error) {
      state = AvatarPickerState.error(message: error.toString());
    }
  }
}
