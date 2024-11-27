// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fill_profile_notifier.g.dart';

@riverpod
class FillProfileNotifier extends _$FillProfileNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String nickname, required String displayName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final avatarFile =
          ref.read(avatarProcessorNotifierProvider).whenOrNull(processed: (file) => file);
      if (avatarFile != null) {
        await ref.read(onboardingDataProvider.notifier).uploadAvatar(avatarFile);
      }
      ref.read(onboardingDataProvider.notifier).name = nickname;
      ref.read(onboardingDataProvider.notifier).displayName = displayName;
    });
  }
}
