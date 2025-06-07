// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/features/auth/data/models/onboarding_state.c.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_data_provider.c.g.dart';

@riverpod
class OnboardingData extends _$OnboardingData {
  @override
  OnboardingState build() {
    listenSelf((_, next) => _saveState(next));
    return _loadSavedState();
  }

  set name(String name) {
    state = state.copyWith(name: name);
  }

  set displayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  set referralName(String referralName) {
    state = state.copyWith(referralName: referralName);
  }

  set languages(List<String> languages) {
    state = state.copyWith(languages: languages);
  }

  set followees(List<String> followees) {
    state = state.copyWith(followees: followees);
  }

  set avatar(MediaFile? avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void _saveState(OnboardingState? state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || state == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_onboardingPersistanceKey, json.encode(state.toJson()));
  }

  OnboardingState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return const OnboardingState();
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedState = userPreferencesService.getValue<String>(_onboardingPersistanceKey);

    if (savedState == null) {
      return const OnboardingState();
    }

    return OnboardingState.fromJson(json.decode(savedState) as Map<String, dynamic>);
  }

  static const _onboardingPersistanceKey = 'onboarding_data';
}
