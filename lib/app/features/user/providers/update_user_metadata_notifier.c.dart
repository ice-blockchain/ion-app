// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_metadata_notifier.c.g.dart';

@riverpod
class UpdateUserMetadataNotifier extends _$UpdateUserMetadataNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> publish(UserMetadata userMetadata, {MediaFile? avatar, MediaFile? banner}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = userMetadata.copyWith();

      final (uploadedAvatar, uploadedBanner) =
          await (_upload(avatar, alt: FileAlt.avatar), _upload(banner, alt: FileAlt.banner)).wait;

      final files = [uploadedAvatar, uploadedBanner]
          .whereType<UploadResult>()
          .map((result) => result.fileMetadata);

      if (uploadedAvatar != null) {
        final attachment = uploadedAvatar.mediaAttachment;
        data = data.copyWith(
          picture: attachment.url,
          media: {...data.media, attachment.url: attachment},
        );
      }

      if (uploadedBanner != null) {
        final attachment = uploadedBanner.mediaAttachment;
        data = data.copyWith(
          banner: attachment.url,
          media: {...data.media, attachment.url: attachment},
        );
      }

      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, data]);
    });
  }

  Future<UploadResult?> _upload(MediaFile? file, {required FileAlt alt}) {
    return file != null
        ? ref.read(nostrUploadNotifierProvider.notifier).upload(file, alt: alt)
        : Future<UploadResult?>.value();
  }
}
