// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/data/models/media_selection_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_selection_provider.g.dart';

@riverpod
class MaxSelection extends _$MaxSelection {
  @override
  int build() => 5;

  Future<void> update(int newValue) async {
    state = newValue;
  }
}

@riverpod
class MediaSelectionNotifier extends _$MediaSelectionNotifier {
  @override
  MediaSelectionState build() => const MediaSelectionState(selectedMedia: []);

  void toggleSelection(String path) {
    final maxSelection = ref.read(maxSelectionProvider);
    final isSelected = state.selectedMedia.any((media) => media.path == path);

    if (isSelected) {
      _deselectMedia(path);
    } else if (state.selectedMedia.length < maxSelection) {
      _selectMedia(path);
    }
  }

  void _deselectMedia(String path) {
    final updatedMedia = state.selectedMedia.where((media) => media.path != path).toList();
    state = state.copyWith(selectedMedia: updatedMedia);
  }

  void _selectMedia(String path) {
    final galleryState = ref.read(galleryNotifierProvider).value;
    if (galleryState == null) return;

    final mediaData = galleryState.mediaData.firstWhereOrNull((media) => media.path == path);
    if (mediaData == null) return;

    state = state.copyWith(
      selectedMedia: [
        ...state.selectedMedia,
        mediaData,
      ],
    );
  }
}

@riverpod
({bool isSelected, int? order}) mediaSelectionState(Ref ref, String path) {
  final selectedMedia = ref.watch(
    mediaSelectionNotifierProvider.select((state) => state.selectedMedia),
  );

  final index = selectedMedia.indexWhere((media) => media.path == path);

  return (
    isSelected: index >= 0,
    order: index >= 0 ? index + 1 : null,
  );
}
