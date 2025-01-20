// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/data/channel_type.dart';
import 'package:ion/app/features/chat/community/data/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_provider.c.g.dart';

@riverpod
class ChannelNotifier extends _$ChannelNotifier {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> createChannel(String name, String? description, ChannelType channelType) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatar = await _uploadAvatar();
      final channelAdmins = ref.read(channelAdminsProvider());

      final communityDefinitionData = CommunityDefinitionData.fromData(
        name: name,
        description: description,
        isPublic: channelType == ChannelType.public,
        isOpen: channelType == ChannelType.public,
        commentsEnabled: true,
        avatar: avatar,
        roleRequiredForPosting: RoleRequiredForPosting.moderator,
        moderators: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.moderator)
            .map((entry) => entry.key)
            .toList(),
        admins: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.admin)
            .map((entry) => entry.key)
            .toList(),
      );

      final result = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData(communityDefinitionData);

      if (result == null) {
        throw FailedToCreateChannelException();
      }

      return result.id;
    });
  }

  Future<void> editChannel(
    CommunityDefinitionData channel,
    String name,
    String? description,
    ChannelType channelType,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatar = await _uploadAvatar();
      final channelAdmins = ref.read(channelAdminsProvider());

      final editedChannelEntity = channel.copyWith(
        avatar: avatar,
        name: name,
        description: description,
        isPublic: channelType == ChannelType.public,
        moderators: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.moderator)
            .map((entry) => entry.key)
            .toList(),
        admins: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.admin)
            .map((entry) => entry.key)
            .toList(),
      );

      final patchChannelEntity = CommunityDefinitionEditData(data: editedChannelEntity);

      final patchChannelResult =
          await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(patchChannelEntity);

      final editChannelResult =
          await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(editedChannelEntity);

      if (patchChannelResult == null || editChannelResult == null) {
        throw FailedToEditChannelException();
      }
      return;
    });
  }

  Future<MediaAttachment?> _uploadAvatar() async {
    final avatarFile = ref.read(avatarProcessorNotifierProvider).whenOrNull(
          processed: (file) => file,
        );

    if (avatarFile == null) {
      return null;
    }

    final compressedImage =
        await ref.read(compressServiceProvider).compressImage(MediaFile(path: avatarFile.path));

    final uploadAvatarResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(compressedImage, alt: FileAlt.avatar);

    return uploadAvatarResult.mediaAttachment;
  }
}
