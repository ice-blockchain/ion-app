import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/media_utils.dart';
import 'media_service.dart';

class MediaServiceImpl implements MediaService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<List<ImageData>> fetchGalleryImages() async {
    return await MediaUtils.fetchGalleryImages();
  }

  @override
  Future<ImageData?> saveCameraImage(XFile image) async {
    return await MediaUtils.saveCameraImage(image);
  }

  @override
  Future<ImageData?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await saveCameraImage(image);
    }
    return null;
  }

  @override
  Future<ImageData?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return await saveCameraImage(image);
    }
    return null;
  }
}
