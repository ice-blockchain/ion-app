// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/models/community_visibility_type.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/providers/invite_to_community_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/join_community_provider.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_community_provider.c.g.dart';

@riverpod
class CreateCommunityNotifier extends _$CreateCommunityNotifier {
  @override
  FutureOr<CommunityDefinitionData?> build() {
    return null;
  }

  Future<void> createChannel(
    String name,
    String? description,
    CommunityVisibilityType channelType,
    RoleRequiredForPosting? roleRequiredForPosting,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatar = await _uploadAvatar();
      final channelAdmins = ref.read(channelAdminsProvider());

      final communityDefinitionData = CommunityDefinitionData.fromData(
        name: name,
        description: description,
        isPublic: channelType == CommunityVisibilityType.public,
        isOpen: channelType == CommunityVisibilityType.public,
        commentsEnabled: true,
        avatar: avatar,
        roleRequiredForPosting: roleRequiredForPosting,
        moderators: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.moderator)
            .map((entry) => entry.key)
            .toList(),
        admins: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.admin)
            .map((entry) => entry.key)
            .toList(),
      );

      final channelEntity = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData<CommunityDefinitionEntity>(communityDefinitionData);

      if (channelEntity == null) {
        throw FailedToCreateChannelException();
      }

      // join community as owner and invite moderators/admins
      await Future.wait([
        ref.read(joinCommunityProvider(channelEntity.data.uuid).future),
        ...channelAdmins.entries.map(
          (admin) => ref.read(inviteToCommunityProvider(channelEntity.data.uuid, admin.key).future),
        ),
      ]);

      return channelEntity.data;
    });
  }

  Future<MediaAttachment?> _uploadAvatar() async {
    final avatarFile =
        ref.read(imageProcessorNotifierProvider(ImageProcessingType.avatar)).whenOrNull(
              processed: (file) => file,
            );

    if (avatarFile == null) {
      return null;
    }
    final uploadAvatarResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(avatarFile, alt: FileAlt.avatar);

    return uploadAvatarResult.mediaAttachment;
  }
}
