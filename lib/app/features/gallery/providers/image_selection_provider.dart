import 'package:collection/collection.dart';
import 'package:ice/app/features/gallery/data/models/image_data.dart';
import 'package:ice/app/features/gallery/data/models/image_selection_state.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_selection_provider.g.dart';

@riverpod
class ImageSelectionNotifier extends _$ImageSelectionNotifier {
  @override
  ImageSelectionState build() => const ImageSelectionState(selectedImages: []);

  void toggleSelection(String assetId) {
    final maxSelection = ref.read(maxSelectionProvider);
    final isSelected = state.selectedImages.any((img) => img.asset.id == assetId);

    if (isSelected) {
      _deselectImage(assetId);
    } else if (state.selectedImages.length < maxSelection) {
      _selectImage(assetId);
    }
  }

  void _deselectImage(String assetId) {
    final updatedImages = state.selectedImages.where((img) => img.asset.id != assetId).toList();
    state = state.copyWith(selectedImages: updatedImages);
    _updateOrder();
  }

  void _selectImage(String assetId) {
    final galleryState = ref.read(galleryImagesNotifierProvider).value;
    if (galleryState == null) return;

    final imageData = galleryState.images.firstWhereOrNull((img) => img.asset.id == assetId);
    if (imageData == null) return;

    final newImage = ImageData(
      asset: imageData.asset,
      order: state.selectedImages.length + 1,
      isFromCamera: false,
    );

    state = state.copyWith(selectedImages: [...state.selectedImages, newImage]);
  }

  void _updateOrder() {
    final updatedImages = state.selectedImages.mapIndexed((index, image) {
      return image.order != index + 1 ? image.copyWith(order: index + 1) : image;
    }).toList();

    state = state.copyWith(selectedImages: updatedImages);
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
