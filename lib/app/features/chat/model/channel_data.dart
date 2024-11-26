// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/services/media_service/media_service.dart';

part 'channel_data.freezed.dart';

@freezed
class ChannelData with _$ChannelData {
  const factory ChannelData({
    required String id,
    required String link,
    required String name,
    required String description,
    required Map<String, ChannelAdminType> admins,
    required List<String> users,
    required ChannelType channelType,
    MediaFile? image,
    bool? isVerified,
  }) = _ChannelData;
}
