// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'article_cover_processor_notifier.c.freezed.dart';
part 'article_cover_processor_notifier.c.g.dart';

@freezed
sealed class ArticleCoverProcessorState with _$ArticleCoverProcessorState {
  const factory ArticleCoverProcessorState.initial() = ArticleCoverProcessorStateInitial;

  const factory ArticleCoverProcessorState.picked({required MediaFile file}) =
      ArticleCoverProcessorStatePicked;

  const factory ArticleCoverProcessorState.cropped({required MediaFile file}) =
      ArticleCoverProcessorStateCropped;

  const factory ArticleCoverProcessorState.processed({
    required MediaFile file,
  }) = ArticleCoverProcessorStateProcessed;

  const factory ArticleCoverProcessorState.error({required String message}) =
      ArticleCoverProcessorStateError;
}

@riverpod
class ArticleCoverProcessorNotifier extends _$ArticleCoverProcessorNotifier {
  @override
  ArticleCoverProcessorState build() => const ArticleCoverProcessorState.initial();

  Future<void> process({
    required String assetId,
    required CropImageUiSettings cropUiSettings,
  }) async {
    final mediaService = ref.read(mediaServiceProvider);
    final compressService = ref.read(compressServiceProvider);

    try {
      state = const ArticleCoverProcessorState.initial();

      final assetEntity = await ref.read(assetEntityProvider(assetId).future);
      if (assetEntity == null) {
        throw AssetEntityFileNotFoundException();
      }

      final assetFile = await assetEntity.file;
      if (assetFile == null) {
        throw AssetEntityFileNotFoundException();
      }

      state = ArticleCoverProcessorState.picked(
        file: MediaFile(
          path: assetFile.path,
          width: assetEntity.width,
          height: assetEntity.height,
        ),
      );

      final croppedImage = await mediaService.cropImage(
        uiSettings: cropUiSettings,
        path: assetFile.path,
        aspectRatio: ArticleConstants.cropAspectRatio,
      );
      if (croppedImage == null) {
        state = const ArticleCoverProcessorState.initial();
        return;
      }

      final dimension = await compressService.getImageDimension(path: croppedImage.path);
      final croppedWithSize = MediaFile(
        path: croppedImage.path,
        width: dimension.width,
        height: dimension.height,
      );
      state = ArticleCoverProcessorState.cropped(file: croppedWithSize);

      final compressedImage = await compressService.compressImage(
        croppedWithSize,
        width: ArticleConstants.compressedImageWidth,
        height: ArticleConstants.compressedImageHeight,
      );
      state = ArticleCoverProcessorState.processed(file: compressedImage);
    } catch (error) {
      state = ArticleCoverProcessorState.error(message: error.toString());
    }
  }
}
