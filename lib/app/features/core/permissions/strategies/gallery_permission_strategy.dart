import 'package:ice/app/features/core/permissions/data/models/models.dart';
import 'package:ice/app/features/core/permissions/strategies/strategies.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class MobileGalleryPermissionStrategy extends BaseMobilePermissionStrategy {
  @override
  Permission get permission => Permission.photos;
}

class MacOsGalleryPermissionStrategy extends PermissionStrategy {
  @override
  Future<AppPermissionStatus> checkPermission() async {
    // this is handled inside requestPermission, so we can return notAvailable here
    return AppPermissionStatus.notAvailable;
  }

  @override
  Future<AppPermissionStatus> requestPermission() async {
    final result = await PhotoManager.requestPermissionExtend();

    return _mapPhotoManagerResult(result);
  }

  AppPermissionStatus _mapPhotoManagerResult(PermissionState result) {
    if (result.isAuth) return AppPermissionStatus.granted;
    if (result.hasAccess) return AppPermissionStatus.limited;

    return AppPermissionStatus.denied;
  }
}
