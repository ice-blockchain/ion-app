import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_capture_provider.g.dart';

@riverpod
class MediaCaptureNotifier extends _$MediaCaptureNotifier {
  @override
  void build() {}

  Future<void> captureImage() async {
    final mediaService = ref.read(mediaServiceProvider);
    final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

    final mediaData = await mediaService.captureImageFromCamera();

    if (mediaData != null) {
      await ref.read(galleryMediaNotifierProvider.notifier).refresh();
      mediaSelectionNotifier.toggleSelection(mediaData.asset.id);
    }
  }
}
