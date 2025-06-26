// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/data/models/media_selection_state.f.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_selection_provider.r.g.dart';

@riverpod
class MediaSelectionNotifier extends _$MediaSelectionNotifier {
  @override
  MediaSelectionState build() {
    return const MediaSelectionState(
      selectedMedia: [],
      maxSelection: 5,
    );
  }

  void updateMaxSelection(int newMaxSelection) {
    state = state.copyWith(maxSelection: newMaxSelection);
  }

  void updateDurationLimit(int? durationLimitInSeconds) {
    state = state.copyWith(maxVideoDurationInSeconds: durationLimitInSeconds);
  }

  void toggleSelection(String path, {MediaPickerType type = MediaPickerType.common}) {
    final isSelected = state.selectedMedia.any((media) => media.path == path);
    if (isSelected) {
      _deselectMedia(path);
    } else if (state.selectedMedia.length < state.maxSelection) {
      _selectMedia(path, type);
    }
  }

  void _deselectMedia(String path) {
    final updatedMedia = state.selectedMedia.where((media) => media.path != path).toList();
    state = state.copyWith(selectedMedia: updatedMedia);
  }

  void _selectMedia(String path, MediaPickerType type) {
    final galleryState = ref.read(galleryNotifierProvider(type: type)).value;
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
