// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_data.freezed.dart';

@freezed
class ContactData with _$ContactData {
  const factory ContactData({
    required String id,
    required String name,
    required String icon,
    required bool hasIceAccount,
    String? nickname,
    String? phoneNumber,
    bool? isVerified,
    DateTime? lastSeen,
  }) = _ContactData;
}
