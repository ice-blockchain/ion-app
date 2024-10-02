// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/core/permissions/strategies/strategies.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileGalleryPermissionStrategy extends BasePermissionStrategy {
  @override
  Permission get permission => Permission.photos;
}
