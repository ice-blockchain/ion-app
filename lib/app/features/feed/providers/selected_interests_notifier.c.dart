// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_interests_notifier.c.g.dart';

@riverpod
class SelectedInterestsNotifier extends _$SelectedInterestsNotifier {
  @override
  List<String> build() {
    return [];
  }

  set selectInterests(List<String> interestsKeys) {
    state = interestsKeys;
  }
}
