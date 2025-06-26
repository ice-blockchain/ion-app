// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_posting_provider.r.g.dart';

@riverpod
class SchedulePosting extends _$SchedulePosting {
  @override
  DateTime build() {
    return DateTime.now();
  }

  set selectedDate(DateTime date) {
    state = date;
  }
}
