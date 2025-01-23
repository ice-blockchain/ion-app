// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/community_visibility_type.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_update_data.c.dart';
import 'package:ion/app/features/chat/community/providers/invite_to_community_provider.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_community_provider.c.g.dart';

@riverpod
class UpdateCommunityNotifier extends _$UpdateCommunityNotifier {
  @override
  FutureOr<CommunityDefinitionData?> build() {
    return null;
  }

  Future<void> updateCommunity(
    CommunityDefinitionData community,
    String name,
    String? description,
    CommunityVisibilityType channelType,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatar = await _uploadAvatar() ?? community.avatar;
      final channelAdmins = ref.read(channelAdminsProvider);
      final pubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;

      if (pubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final editedChannelEntity = community.copyWith(
        avatar: avatar,
        name: name,
        description: description,
        isPublic: channelType == CommunityVisibilityType.public,
        moderators: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.moderator)
            .map((entry) => entry.key)
            .toList(),
        admins: channelAdmins.entries
            .where((entry) => entry.value == ChannelAdminType.admin)
            .map((entry) => entry.key)
            .toList(),
      );

      final patchChannelEntity =
          CommunityUpdateData.fromCommunityDefinitionData(editedChannelEntity);
      final patchChannelResult =
          await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(patchChannelEntity);

      final editChannelResult = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData<CommunityDefinitionEntity>(editedChannelEntity);

      if (patchChannelResult == null || editChannelResult == null) {
        throw FailedToEditChannelException();
      }

      final existingAdminsAndModerators = community.admins.toList() + community.moderators.toList();

      final newlyAddedAdminsAndModerators =
          channelAdmins.keys.where((key) => !existingAdminsAndModerators.contains(key)).toList();

      if (newlyAddedAdminsAndModerators.isNotEmpty) {
        await Future.wait(
          newlyAddedAdminsAndModerators.map(
            (pubkey) => ref.read(inviteToCommunityProvider(community.uuid, pubkey).future),
          ),
        );
      }

      return editChannelResult.data;
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
