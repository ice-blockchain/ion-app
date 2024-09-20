import 'package:ice/app/features/camera/data/models/models.dart';
import 'package:ice/app/features/camera/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_selection_provider.g.dart';

@riverpod
class ImageSelectionNotifier extends _$ImageSelectionNotifier {
  @override
  ImageSelectionState build() => const ImageSelectionState(selectedImages: []);

  bool toggleSelection(ImageData imageData) {
    final isSelected = state.selectedImages.any((img) => img.id == imageData.id);
    if (isSelected) {
      state = state.copyWith(
        selectedImages: state.selectedImages.where((img) => img.id != imageData.id).toList(),
      );
      _updateOrder();
      return true;
    } else {
      final maxSelection = ref.read(maxSelectionProvider);
      if (state.selectedImages.length >= maxSelection) {
        return false;
      }
      state = state.copyWith(
        selectedImages: [
          ...state.selectedImages,
          imageData.copyWith(order: state.selectedImages.length + 1)
        ],
      );
      return true;
    }
  }

  Future<void> captureAndAddImageFromSystemCamera() async {
    final mediaService = ref.read(cameraMediaServiceProvider);
    if (mediaService == null) return;

    final imageData = await mediaService.captureImageFromSystemCamera();
    if (imageData != null) {
      _addImage(imageData);

      await ref.read(galleryImagesNotifierProvider.notifier).reset();

      final updatedGalleryState = await ref.read(galleryImagesNotifierProvider.future);
      final newImageInGallery = updatedGalleryState.images.firstWhere(
        (img) => img.id == imageData.id,
        orElse: () => imageData,
      );

      toggleSelection(newImageInGallery);
    }
  }

  void _addImage(ImageData image) {
    final maxSelection = ref.read(maxSelectionProvider);
    if (state.selectedImages.length < maxSelection) {
      state = state.copyWith(
        selectedImages: [
          ...state.selectedImages,
          image.copyWith(order: state.selectedImages.length + 1)
        ],
      );
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
({bool isSelected, int? order}) imageSelectionState(ImageSelectionStateRef ref, String imageId) {
  final selectedImages = ref.watch(
    imageSelectionNotifierProvider.select((state) => state.selectedImages),
  );

  for (final img in selectedImages) {
    if (img.id == imageId) {
      return (
        isSelected: true,
        order: img.order,
      );
    }
  }

  return (isSelected: false, order: null);
}
