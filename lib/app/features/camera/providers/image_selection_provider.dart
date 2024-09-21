import 'package:collection/collection.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:ice/app/features/camera/data/models/image_selection_state.dart';
import 'package:ice/app/features/camera/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_selection_provider.g.dart';

@riverpod
class ImageSelectionNotifier extends _$ImageSelectionNotifier {
  @override
  ImageSelectionState build() => const ImageSelectionState(selectedImages: []);

  bool toggleSelection(String assetId) {
    final isSelected = state.selectedImages.any((img) => img.asset.id == assetId);

    if (isSelected) {
      state = state.copyWith(
        selectedImages: state.selectedImages.where((img) => img.asset.id != assetId).toList(),
      );

      _updateOrder();

      return true;
    } else {
      final maxSelection = ref.read(maxSelectionProvider);

      if (state.selectedImages.length >= maxSelection) {
        return false;
      }

      final galleryState = ref.read(galleryImagesNotifierProvider).value;
      if (galleryState == null) return false;

      final imageData = galleryState.images.firstWhereOrNull((img) => img.asset.id == assetId);
      if (imageData == null) return false;

      final newImage = ImageData(
        asset: imageData.asset,
        order: state.selectedImages.length + 1,
        isFromCamera: imageData.isFromCamera,
      );

      state = state.copyWith(
        selectedImages: [
          ...state.selectedImages,
          newImage,
        ],
      );

      return true;
    }
  }

  Future<void> captureAndAddImageFromCamera() async {
    final mediaService = ref.read(mediaServiceProvider);

    final imageData = await mediaService.captureImageFromCamera();

    if (imageData != null) {
      await ref.read(galleryImagesNotifierProvider.notifier).reset();
      await ref.read(galleryImagesNotifierProvider.future);

      toggleSelection(imageData.asset.id);
    }
  }

  void _updateOrder() {
    state = state.copyWith(
      selectedImages: state.selectedImages.asMap().entries.map((entry) {
        final index = entry.key;
        final image = entry.value;

        return image.copyWith(order: index + 1);
      }).toList(),
    );
  }
}

@riverpod
({bool isSelected, int? order}) imageSelectionState(ImageSelectionStateRef ref, String assetId) {
  final selectedImages = ref.watch(
    imageSelectionNotifierProvider.select((state) => state.selectedImages),
  );

  final image = selectedImages.firstWhereOrNull((img) => img.asset.id == assetId);

  return image != null
      ? (
          isSelected: true,
          order: image.order,
        )
      : (
          isSelected: false,
          order: null,
        );
}
