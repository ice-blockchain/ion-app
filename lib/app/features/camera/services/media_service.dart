import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:image_picker/image_picker.dart';

abstract class MediaService {
  Future<List<ImageData>> fetchGalleryImages();

  Future<ImageData?> saveCameraImage(XFile image);

  Future<ImageData?> pickImageFromGallery();

  Future<ImageData?> pickImageFromCamera();
}
