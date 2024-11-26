// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_notifier.g.dart';

@riverpod
class UserMetadataNotifier extends _$UserMetadataNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> send(UserMetadata userMetadata, {MediaFile? avatar, MediaFile? banner}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = userMetadata.copyWith();

      final (uploadedAvatar, uploadedBanner) = await (_upload(avatar), _upload(banner)).wait;

      final files = [uploadedAvatar, uploadedBanner]
          .whereType<(FileMetadata, MediaAttachment)>()
          .map((result) => result.$1);

      if (uploadedAvatar != null) {
        final attachment = uploadedAvatar.$2;
        data = data.copyWith(
          picture: attachment.url,
          media: {...data.media, attachment.url: attachment},
        );
      }

      if (uploadedBanner != null) {
        final attachment = uploadedBanner.$2;
        data = data.copyWith(
          banner: attachment.url,
          media: {...data.media, attachment.url: attachment},
        );
      }

      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, data]);
    });
  }

  Future<(FileMetadata, MediaAttachment)?> _upload(MediaFile? file) {
    return file != null
        ? ref.read(nostrUploadNotifierProvider.notifier).upload(file)
        : Future<(FileMetadata, MediaAttachment)?>.value();
  }
}
