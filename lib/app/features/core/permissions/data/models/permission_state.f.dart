// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';

part 'permission_state.f.freezed.dart';

@freezed
class PermissionsState with _$PermissionsState {
  const factory PermissionsState({
    @Default({}) Map<Permission, PermissionStatus> permissions,
  }) = _PermissionsState;
}
