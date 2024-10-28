// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_data_provider.freezed.dart';
part 'onboarding_data_provider.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    MediaAttachment? avatarMediaAttachment,
    FileMetadata? avatarFileMetadata,
    String? name,
    String? displayName,
    List<String>? languages,
    List<String>? followees,
  }) = _OnboardingState;
}

@Riverpod(keepAlive: true)
class OnboardingData extends _$OnboardingData {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  set name(String name) {
    state = state.copyWith(name: name);
  }

  set displayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  set languages(List<String> languages) {
    state = state.copyWith(languages: languages);
  }

  set followees(List<String> followees) {
    state = state.copyWith(followees: followees);
  }

  Future<void> uploadAvatar(MediaFile avatar) async {
    await _generateNostrKeyStore();
    final (fileMetadata, mediaAttachment) =
        await ref.read(nostrUploadNotifierProvider.notifier).upload(avatar);
    state =
        state.copyWith(avatarFileMetadata: fileMetadata, avatarMediaAttachment: mediaAttachment);
  }

  Future<void> _generateNostrKeyStore() async {
    if (await ref.read(currentUserNostrKeyStoreProvider.future) == null) {
      final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
      await ref.read(nostrKeyStoreProvider(currentIdentityKeyName).notifier).generate();
    }
  }
}
