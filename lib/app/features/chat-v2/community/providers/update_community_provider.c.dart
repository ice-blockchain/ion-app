// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/models/community_admin_type.dart';
import 'package:ion/app/features/chat-v2/community/models/community_visibility_type.dart';
import 'package:ion/app/features/chat-v2/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat-v2/community/models/entities/community_update_data.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_admins_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/invite_to_community_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_community_provider.c.g.dart';

@riverpod
class UpdateCommunityNotifier extends _$UpdateCommunityNotifier {
  @override
  FutureOr<CommunityDefinitionData?> build(CommunityDefinitionData community) {
    return null;
  }

  Future<void> updateCommunity(
    String name,
    String? description,
    CommunityVisibilityType communityVisibilityType,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatar = await _uploadAvatar();
      final communityAdmins = ref.read(communityAdminsProvider);
      final pubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;

      if (pubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final editedCommunityEntity = community.copyWith(
        avatar: avatar?.mediaAttachment ?? community.avatar,
        name: name,
        description: description,
        isPublic: communityVisibilityType == CommunityVisibilityType.public,
        moderators: communityAdmins.entries
            .where((entry) => entry.value == CommunityAdminType.moderator)
            .map((entry) => entry.key)
            .toList(),
        admins: communityAdmins.entries
            .where((entry) => entry.value == CommunityAdminType.admin)
            .map((entry) => entry.key)
            .toList(),
      );

      final patchCommunityEntity =
          CommunityUpdateData.fromCommunityDefinitionData(editedCommunityEntity);
      final patchCommunityResult =
          await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(patchCommunityEntity);

      final editCommunityResult = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData<CommunityDefinitionEntity>(editedCommunityEntity);

      if (patchCommunityResult == null || editCommunityResult == null) {
        throw FailedToEditCommunityException();
      }

      if (avatar != null) {
        unawaited(
          ref.read(ionConnectNotifierProvider.notifier).sendEntityData(avatar.fileMetadata),
        );
      }

      final existingAdminsAndModerators = community.admins.toList() + community.moderators.toList();

      final newlyAddedAdminsAndModerators =
          communityAdmins.keys.where((key) => !existingAdminsAndModerators.contains(key)).toList();

      if (newlyAddedAdminsAndModerators.isNotEmpty) {
        newlyAddedAdminsAndModerators.map(
          (pubkey) => ref.read(inviteToCommunityNotifierProvider.notifier).inviteToCommunity(
                community.uuid,
                pubkey,
              ),
        );
      }

      ref.invalidate(communityMetadataProvider(community.uuid));

      return editCommunityResult.data;
    });
  }

  Future<UploadResult?> _uploadAvatar() async {
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

    return uploadAvatarResult;
  }
}
