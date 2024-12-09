// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/media_compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'banner_processor_notifier.c.freezed.dart';
part 'banner_processor_notifier.c.g.dart';

@freezed
sealed class BannerProcessorState with _$BannerProcessorState {
  const factory BannerProcessorState.initial() = BannerProcessorStateInitial;

  const factory BannerProcessorState.picked({required MediaFile file}) = BannerProcessorStatePicked;

  const factory BannerProcessorState.cropped({required MediaFile file}) =
      BannerProcessorStateCropped;

  const factory BannerProcessorState.processed({required MediaFile file}) =
      BannerProcessorStateProcessed;

  const factory BannerProcessorState.error({required String message}) = BannerProcessorStateError;
}

@riverpod
class BannerProcessorNotifier extends _$BannerProcessorNotifier {
  @override
  BannerProcessorState build() {
    return const BannerProcessorState.initial();
  }

  Future<void> process({
    required String assetId,
    required CropImageUiSettings cropUiSettings,
  }) async {
    final mediaService = ref.read(mediaServiceProvider);
    final compressService = ref.read(mediaCompressServiceProvider);

    try {
      state = const BannerProcessorState.initial();
      final assetImagePath = await ref.read(assetFilePathProvider(assetId).future);
      if (assetImagePath == null) {
        throw AssetEntityFileNotFoundException();
      }
      state = BannerProcessorState.picked(file: MediaFile(path: assetImagePath));

      final croppedImage = await mediaService.cropImage(
        uiSettings: cropUiSettings,
        path: assetImagePath,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      );
      if (croppedImage == null) {
        state = const BannerProcessorState.initial();
        return;
      }

      state = BannerProcessorState.cropped(file: croppedImage);

      final compressedImage = await compressService.compressImage(
        croppedImage,
        width: 1024,
        height: 768,
        quality: 70,
      );
      state = BannerProcessorState.processed(file: compressedImage);
    } catch (error) {
      state = BannerProcessorState.error(message: error.toString());
    }
  }
}
