// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_processor_notifier.freezed.dart';
part 'avatar_processor_notifier.g.dart';

@freezed
sealed class AvatarProcessorState with _$AvatarProcessorState {
  const factory AvatarProcessorState.initial() = AvatarProcessorStateInitial;

  const factory AvatarProcessorState.picked({required MediaFile file}) = AvatarProcessorStatePicked;

  const factory AvatarProcessorState.cropped({required MediaFile file}) =
      AvatarProcessorStateCropped;

  const factory AvatarProcessorState.processed({required MediaFile file}) =
      AvatarProcessorStateProcessed;

  const factory AvatarProcessorState.error({required String message}) = AvatarProcessorStateError;
}

@riverpod
class AvatarProcessorNotifier extends _$AvatarProcessorNotifier {
  @override
  AvatarProcessorState build() {
    return const AvatarProcessorState.initial();
  }

  Future<void> process({
    required String assetId,
    required CropImageUiSettings cropUiSettings,
  }) async {
    final mediaService = ref.read(mediaServiceProvider);
    final compressService = ref.read(mediaCompressServiceProvider);

    try {
      state = const AvatarProcessorState.initial();
      final assetImagePath = await ref.read(assetFilePathProvider(assetId).future);
      if (assetImagePath == null) {
        throw AssetEntityFileNotFoundException();
      }
      state = AvatarProcessorState.picked(file: MediaFile(path: assetImagePath));
      final croppedImage = await mediaService.cropImage(
        uiSettings: cropUiSettings,
        path: assetImagePath,
      );
      if (croppedImage == null) {
        state = const AvatarProcessorState.initial();
        return;
      }
      state = AvatarProcessorState.cropped(file: croppedImage);
      final compressedImage = await compressService.compressImage(
        croppedImage,
        width: 720,
        height: 720,
        quality: 70,
      );
      state = AvatarProcessorState.processed(file: compressedImage);
    } catch (error) {
      state = AvatarProcessorState.error(message: error.toString());
    }
  }
}
