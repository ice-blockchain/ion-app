// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_data_provider.freezed.dart';
part 'onboarding_data_provider.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    MediaFile? avatar,
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

  set avatar(MediaFile avatar) {
    state = state.copyWith(avatar: avatar);
  }
}
