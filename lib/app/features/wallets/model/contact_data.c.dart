// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_data.c.freezed.dart';

@freezed
class ContactData with _$ContactData {
  const factory ContactData({
    required String pubkey,
    required String name,
    required String icon,
    String? nickname,
    bool? isVerified,
    DateTime? lastSeen,
  }) = _ContactData;
}
