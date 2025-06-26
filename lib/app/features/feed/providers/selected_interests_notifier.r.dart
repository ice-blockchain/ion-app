// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_interests_notifier.r.g.dart';

@riverpod
class SelectedInterestsNotifier extends _$SelectedInterestsNotifier {
  @override
  Set<String> build() {
    return {};
  }

  set selectInterests(Set<String> interestsKeys) {
    state = interestsKeys;
  }
}
