// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

part 'onboarding_state.c.freezed.dart';
part 'onboarding_state.c.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    MediaFile? avatar,
    String? name,
    String? displayName,
    String? referralName,
    List<String>? languages,
    List<String>? followees,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) => _$OnboardingStateFromJson(json);
}
