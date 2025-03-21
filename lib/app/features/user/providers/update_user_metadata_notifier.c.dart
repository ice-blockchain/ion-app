// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/settings/model/privacy_options.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_metadata_notifier.c.g.dart';

@riverpod
class UpdateUserMetadataNotifier extends _$UpdateUserMetadataNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> publish(UserMetadata userMetadata, {MediaFile? avatar, MediaFile? banner}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = userMetadata.copyWith(
        website: userMetadata.website != null
            ? normalizeUrl(userMetadata.website!)
            : userMetadata.website,
      );

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

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([...files, data]);
    });
  }

  Future<void> publishWallets(WalletAddressPrivacyOption option) async {
    Map<String, String>? wallets;
    if (option == WalletAddressPrivacyOption.public) {
      final cryptoWallets = await ref.read(connectedCryptoWalletsProvider.future);
      wallets = Map.fromEntries(
        cryptoWallets.map((wallet) {
          if (wallet.address == null) return null;
          return MapEntry(wallet.network, wallet.address!);
        }).nonNulls,
      );
    }
    final userMetadata = await ref.read(currentUserMetadataProvider.future);
    if (userMetadata != null) {
      // Compare the current wallets with the newly computed wallets.
      final currentWallets = userMetadata.data.wallets;
      const equality = DeepCollectionEquality();
      if (equality.equals(currentWallets, wallets)) {
        return;
      }
      final updatedMetadata = userMetadata.data.copyWith(wallets: wallets);
      await publish(updatedMetadata);
    }
  }

  Future<void> updatePublishedWallets() async {
    final userMetadata = await ref.read(currentUserMetadataProvider.future);
    if (userMetadata != null) {
      final walletPrivacy = WalletAddressPrivacyOption.fromWalletsMap(userMetadata.data.wallets);
      if (walletPrivacy == WalletAddressPrivacyOption.public) {
        await publishWallets(WalletAddressPrivacyOption.public);
      }
    }
  }

  Future<UploadResult?> _upload(MediaFile? file, {required FileAlt alt}) {
    return file != null
        ? ref.read(ionConnectUploadNotifierProvider.notifier).upload(file, alt: alt)
        : Future<UploadResult?>.value();
  }
}
