import 'package:collection/collection.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:ice/app/features/gallery/data/models/media_selection_state.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_selection_provider.g.dart';

@riverpod
class MediaSelectionNotifier extends _$MediaSelectionNotifier {
  @override
  MediaSelectionState build() => const MediaSelectionState(selectedMedia: []);

  void toggleSelection(String assetId) {
    final maxSelection = ref.read(maxSelectionProvider);
    final isSelected = state.selectedMedia.any((media) => media.asset.id == assetId);

    if (isSelected) {
      _deselectMedia(assetId);
    } else if (state.selectedMedia.length < maxSelection) {
      _selectMedia(assetId);
    }
  }

  void _deselectMedia(String assetId) {
    final updatedMedia = state.selectedMedia.where((media) => media.asset.id != assetId).toList();
    state = state.copyWith(selectedMedia: updatedMedia);
    _updateOrder();
  }

  void _selectMedia(String assetId) {
    final galleryState = ref.read(galleryNotifierProvider).value;
    if (galleryState == null) return;

    final mediaData = galleryState.mediaData.firstWhereOrNull((media) => media.asset.id == assetId);
    if (mediaData == null) return;

    final newMedia = MediaData(
      asset: mediaData.asset,
      order: state.selectedMedia.length + 1,
    );

    state = state.copyWith(selectedMedia: [...state.selectedMedia, newMedia]);
  }

  void _updateOrder() {
    final updatedMedia = state.selectedMedia.mapIndexed((index, media) {
      return media.order != index + 1 ? media.copyWith(order: index + 1) : media;
    }).toList();

    state = state.copyWith(selectedMedia: updatedMedia);
  }
}

@riverpod
({bool isSelected, int? order}) mediaSelectionState(MediaSelectionStateRef ref, String assetId) {
  final selectedMedia = ref.watch(
    mediaSelectionNotifierProvider.select((state) => state.selectedMedia),
  );

  final image = selectedMedia.firstWhereOrNull((media) => media.asset.id == assetId);

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
