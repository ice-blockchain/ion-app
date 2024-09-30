import 'package:ice/app/features/core/permissions/strategies/base_mobile_permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPermissionStrategy extends BaseMobilePermissionStrategy {
  @override
  Permission get permission => Permission.contacts;
}
