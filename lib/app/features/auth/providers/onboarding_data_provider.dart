// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_data_provider.freezed.dart';
part 'onboarding_data_provider.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? name,
    String? displayName,
    List<String>? languages,
    List<String>? followees,
  }) = _OnboardingState;
}

@Riverpod(keepAlive: true)
class OnboardingData extends _$OnboardingData {
  @override
  OnboardingState? build() {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      return null;
    }

    return const OnboardingState();
  }

  set name(String name) {
    state = state?.copyWith(name: name);
  }

  set displayName(String displayName) {
    state = state?.copyWith(displayName: displayName);
  }

  set languages(List<String> languages) {
    state = state?.copyWith(languages: languages);
  }

  set followees(List<String> followees) {
    state = state?.copyWith(followees: followees);
  }

  ({String name, String displayName, List<String> languages, List<String> followees})
      requireValues() {
    final data = state;

    if (data == null) throw Exception('OnboardingState is empty');

    final OnboardingState(:name, :displayName, :languages, :followees) = data;

    if (name == null) {
      throw Exception('OnboardingState.name is empty');
    }
    if (displayName == null) {
      throw Exception('OnboardingState.displayName is empty');
    }
    if (languages == null || languages.isEmpty) {
      throw Exception('OnboardingState.languages is empty');
    }
    if (followees == null || followees.isEmpty) {
      throw Exception('OnboardingState.followees is empty');
    }
    return (name: name, displayName: displayName, languages: languages, followees: followees);
  }
}
