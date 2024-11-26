// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'banner_picker_notifier.freezed.dart';
part 'banner_picker_notifier.g.dart';

@freezed
sealed class BannerPickerState with _$BannerPickerState {
  const factory BannerPickerState.initial() = BannerPickerStateInitial;

  const factory BannerPickerState.picked({required MediaFile file}) = BannerPickerStatePicked;

  const factory BannerPickerState.processed({required MediaFile file}) = BannerPickerStateProcessed;

  const factory BannerPickerState.error({required String message}) = BannerPickerStateError;
}

@riverpod
class BannerPickerNotifier extends _$BannerPickerNotifier {
  @override
  BannerPickerState build() {
    return const BannerPickerState.initial();
  }

  Future<void> process({required String assetId}) async {
    final compressService = ref.read(mediaCompressServiceProvider);

    try {
      final assetImagePath = await ref.read(assetFilePathProvider(assetId).future);
      if (assetImagePath == null) {
        throw AssetEntityFileNotFoundException();
      }
      state = BannerPickerState.picked(file: MediaFile(path: assetImagePath));
      final compressedImage = await compressService.compressImage(
        MediaFile(path: assetImagePath),
        width: 1024,
        height: 768,
        quality: 70,
      );
      state = BannerPickerState.processed(file: compressedImage);
    } catch (error) {
      state = BannerPickerState.error(message: error.toString());
    }
  }
}
