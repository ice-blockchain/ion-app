// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_model.dart';

part 'blocked_user.c.freezed.dart';

@freezed
class BlockedUser with _$BlockedUser implements OptimisticModel {
  const factory BlockedUser({
    required bool isBlocked,
    required String masterPubkey,
    String? dtag,
  }) = _BlockedUser;
  const BlockedUser._();

  @override
  String get optimisticId => masterPubkey;
}
