import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:ice/app/features/camera/services/media_service.dart';
import 'package:ice/app/features/camera/services/media_service_impl.dart';

part 'media_service_provider.g.dart';

@riverpod
MediaService mediaService(MediaServiceRef ref) {
  return MediaServiceImpl();
}

@riverpod
class SelectedImages extends _$SelectedImages {
  @override
  List<ImageData> build() => [];

  void addImage(ImageData image) {
    if (state.length >= ref.read(maxSelectionProvider)) return;
    state = [...state, image];
  }

  void removeImage(String id) {
    state = state.where((image) => image.id != id).toList();
    state = _updateOrderForImages(state);
  }

  void clear() {
    state = [];
  }

  void reorderImages(List<ImageData> images) {
    state = _updateOrderForImages(images);
  }

  Future<void> selectImageFromGallery() async {
    if (state.length >= ref.read(maxSelectionProvider)) return;
    final imageData = await ref.read(mediaServiceProvider).pickImageFromGallery();
    if (imageData != null) {
      addImage(imageData.copyWith(order: state.length + 1));
    }
  }

  Future<void> selectImageFromCamera() async {
    if (state.length >= ref.read(maxSelectionProvider)) return;
    final imageData = await ref.read(mediaServiceProvider).pickImageFromCamera();
    if (imageData != null) {
      addImage(imageData.copyWith(order: state.length + 1));
    }
  }

  List<ImageData> _updateOrderForImages(List<ImageData> images) {
    return images.asMap().entries.map((entry) {
      return entry.value.copyWith(order: entry.key + 1);
    }).toList();
  }
}

@riverpod
int maxSelection(MaxSelectionRef ref) => 5;

@riverpod
Future<List<ImageData>> galleryImages(GalleryImagesRef ref) async {
  final mediaService = ref.watch(mediaServiceProvider);
  return await mediaService.fetchGalleryImages();
}
