import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';

part 'permission_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
@freezed
class PermissionsState with _$PermissionsState {
  const factory PermissionsState({
    @Default({}) Map<AppPermissionType, AppPermissionStatus> permissions,
  }) = _PermissionsState;
}
