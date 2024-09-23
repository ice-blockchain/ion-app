import 'package:ice/app/features/gallery/services/media_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service_provider.g.dart';

@riverpod
ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@riverpod
MediaService mediaService(MediaServiceRef ref) {
  final imagePicker = ref.watch(imagePickerProvider);

  return MediaService(picker: imagePicker);
}

@riverpod
int maxSelection(MaxSelectionRef ref) => 5;
