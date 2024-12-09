// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poll_length_time_provider.c.g.dart';

@riverpod
class SelectedDayNotifier extends _$SelectedDayNotifier {
  @override
  int build() {
    return 1;
  }

  set day(int newDay) {
    state = newDay;
  }
}

@riverpod
class SelectedHourNotifier extends _$SelectedHourNotifier {
  @override
  int build() {
    return 0;
  }

  set hour(int newHour) {
    state = newHour;
  }
}
